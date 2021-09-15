//
//  ContentView.swift
//  BetterRest
//
//  Created by Andreas Zwikirsch on 13.09.21.
//

import SwiftUI

struct Watermark: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .opacity(0.5)
        }
    }
}

struct DefaultTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.yellow)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .leading)
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        self.modifier(Watermark(text: text))
    }
    
    func defaultTitle() -> some View {
        self.modifier(DefaultTitle())
    }
}


struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    @State private var testVar = 33
    
    var calculatedSleepTime: String {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try
                model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            let timeString = String(formatter.string(from: sleepTime))
            
            return timeString
            
        } catch {
            return "Error"
        }
    }

    
    var body: some View {
        NavigationView {

            Form {
                Label("Recomanded Bedtime: \(calculatedSleepTime)", systemImage: "moon")
                    .font(.title)
                    .foregroundColor(.yellow)
                
                VStack {
                    Text("When do you want to wake up?")
                        .defaultTitle()
                    
                    DatePicker("Please enter a date",
                               selection: $wakeUp,
                               displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                    
                }
                
                VStack(spacing: 20) {
                    Text("Desired amount of sleep")
                        .defaultTitle()
                    
                    HStack{
                        Text("\(sleepAmount, specifier: "%g") hours")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .leading)
                        Stepper("", value: $sleepAmount, in: 4...12, step: 0.25)
                            .labelsHidden()
                            
                    }
                }
                .padding()
                
                VStack(spacing: 20) {
                    Text("Daily coffee intake")
                        .defaultTitle()
                    
                    HStack{
                        if coffeeAmount == 1 {
                            Text("1 cup")
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .leading)
                        } else {
                            Text("\(coffeeAmount) cups")
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .leading)
                        }
                        Stepper("", value: $coffeeAmount, in: 1...20)
                            .labelsHidden()
                    }
                }
                .padding()
                
            }
            .navigationBarTitle("BetterRest")
//            .navigationBarItems(trailing:
//                                    Button(action: calculateBedtime) {
//                                        Text("Calculate")
//                                            .padding(8)
//                                    }
//                                    .defaultTitle()
//                                    .background(Color(red: 0.1, green: 0.1, blue: 0.1))
//                                    .clipShape(RoundedRectangle(cornerRadius: 8))
//                                    .padding(6)
//
//            )
//            .alert(isPresented: $showingAlert) {
//                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            }
            .watermarked(with: "Developed by Zwitschki")
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
//    func calculateBedtime() {
//        let model = SleepCalculator()
//
//        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
//        let hour = (components.hour ?? 0) * 60 * 60
//        let minute = (components.minute ?? 0) * 60
//
//        do {
//            let prediction = try
//                model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
//
//            let sleepTime = wakeUp - prediction.actualSleep
//
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
//
//            alertMessage = formatter.string(from: sleepTime)
//            alertTitle = "Your ideal bedtime is.."
//        } catch {
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calculating your bedtime."
//        }
//
//        showingAlert = true
//    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}
