//
//  ContentView.swift
//  UnitConverter
//
//  Created by Andreas Zwikirsch on 06.09.21.
//

import SwiftUI

struct ContentView: View {
    @State private var unitCentimeter = ""
    @State private var unitToConvert = ""
    @State private var chosenStartUnit = 0
    @State private var chosenConvertUnit = 1
    let onInchInCM = 2.54
    let zeroCelsiusInFahrenheit = 32.0
    
    let units = ["inch", "cm", "°Fahrenheit", "°Celsius"]
    
    var inputUnit: Double {
        let doubleUnitInch = Double(unitToConvert) ?? 0.0

        return doubleUnitInch
    }
    
    var outputUnit: Double {
        let doubleInputUnit = Double(unitToConvert) ?? 0.0
        if chosenStartUnit == 0 && chosenConvertUnit == 1 {
            let result = doubleInputUnit * onInchInCM
            return result
        } else if chosenStartUnit == 1 && chosenConvertUnit == 0 {
            let result = doubleInputUnit / onInchInCM
            return result
        } else if chosenStartUnit == 2 && chosenConvertUnit == 3 {
            let result = doubleInputUnit - zeroCelsiusInFahrenheit
            return result
        } else if chosenStartUnit == 3 && chosenConvertUnit == 2 {
            let result = doubleInputUnit + zeroCelsiusInFahrenheit
            return result
        } else {
            return -404.404
        }
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Convert from")
                    Picker("Start Unit", selection: $chosenStartUnit) {
                        ForEach(0..<units.count) {
                            Text("\(self.units[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Text("to")
                    Picker("Convert to", selection: $chosenConvertUnit) {
                        ForEach(0..<units.count) {
                            Text("\(self.units[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    TextField("input unit", text: $unitToConvert).keyboardType(.decimalPad)
                }
                Section {
                    Text("Unit Convertion Result:")
                    if outputUnit == -404.404 {
                        Text("Something went wrong..\nprobably invalid unit combination...")
                    } else {
                        Text("\(inputUnit, specifier: "%.2f") \(units[chosenStartUnit]) equals \(outputUnit, specifier: "%.2f") \(units[chosenConvertUnit])")
                    }

                }
            }
            .navigationBarTitle("Unit Converter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}
