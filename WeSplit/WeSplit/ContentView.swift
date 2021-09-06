//
//  ContentView.swift
//  WeSplit
//
//  Created by Andreas Zwikirsch on 03.09.21.
//

import SwiftUI


struct ContentView: View {
    @State private var checkAmount = ""
//    @State private var numberOfPeople = 0
    @State private var tipPercentage = 1
    @State private var numbOfPeaopleStr = ""
    
    
    let tipPercentages = [5, 10, 15, 20, 25, 0]
    
    var numberOfPeople: Int {
        let strNumb = Int(numbOfPeaopleStr) ?? 0
        return strNumb
    }
    
    
    var totalPerPerson: Double {
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = (orderAmount / 100) * tipSelection
        let grandTotal = orderAmount + tipValue
        
        if numberOfPeople == 0 {
            let peopleCount = 1.0
            let amountPerPerson = grandTotal / peopleCount
            return amountPerPerson
        } else {
            let peopleCount = Double(numberOfPeople)
            let amountPerPerson = grandTotal / peopleCount
            return amountPerPerson
        }
        
        
        
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount).keyboardType(.decimalPad)
                    TextField("Number of people", text: $numbOfPeaopleStr).keyboardType(.decimalPad)
//                    Picker("Number of people", selection: $numberOfPeople) {
//                        ForEach(1..<100) {
//                            Text("\($0) people")
//                        }
//                    }
                }
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0..<tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section {
                    Text("Number of people").bold()
                    if numberOfPeople == 0 {
                        Text("1 Person")
                    } else {
                        Text("\(numberOfPeople) People")
                    }
                    Text("Amount per persone:").bold()
                    if totalPerPerson > 0.0 {
                        Text("\(totalPerPerson, specifier: "%.2f")€")
                    } else {
                        Text("0.00€")
                    }
                    
                    Text("Total amount without tip:").bold()
                    if checkAmount == "" {
                        Text("0.00€")
                    } else {
                        Text("\(checkAmount)€")
                    }
                }
                Section {
                    Button("close keyboard") {
                        
                    }
                }
                Section {
                    if tipPercentages[tipPercentage] == 5 {
                        Text("Puhh is it already end of the month?")
                    } else if tipPercentages[tipPercentage] == 10 {
                        Text("Yeah thats ok! But if the service was goot, spend a bit more you broke motherfucker!")
                    } else if tipPercentages[tipPercentage] == 15 {
                        Text("Good service and good food has to be rewarded!")
                    } else if tipPercentages[tipPercentage] == 20 {
                        Text("Well well look at that, someone has too much money!")
                    } else if tipPercentages[tipPercentage] == 25 {
                        Text("Wow that's a huge tip! Are you kinda Hunter richt motherfucker?!")
                    } else {
                        Text("Fucking broke student... \nor the service was realy bad!")
                    }
                }
            }
            .navigationBarTitle("WeSplit 💸")
        }
        .foregroundColor(.orange)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}
