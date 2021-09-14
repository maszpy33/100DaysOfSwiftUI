//
//  ContentView.swift
//  BetterRest
//
//  Created by Andreas Zwikirsch on 13.09.21.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date()
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State var circleSize: Float = 20.0
    
    var body: some View {
        NavigationView {

            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Please enter a date",
                           selection: $wakeUp,
                           displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                

                
                VStack(spacing: 10) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    HStack {
                        Text("\(sleepAmount, specifier: "%g") hours")
                        Stepper("", value: $sleepAmount, in: 4...12, step: 0.25)
                            .labelsHidden()
                    }
                }
                .padding()
                

                
                VStack(spacing: 10) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    HStack {
                        if coffeeAmount == 1 {
                            Text("1 cup")
                        } else {
                            Text("\(coffeeAmount) cups")
                        }
                        Stepper("", value: $coffeeAmount, in: 1...20)
                            .labelsHidden()
                    }
                }
                .padding()
            }
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing:
                                    Button(action: calculateBedtime) {
                                        Text("Calculate")
                                    }
                                    .foregroundColor(.orange)
            )
        }
        
    }
    
    func calculateBedtime() {
        print("calculating....")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}
