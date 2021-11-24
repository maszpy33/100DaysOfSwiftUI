//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Andreas Zwikirsch on 18.11.21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var obsOrder = ObservableOrder(order: Order())
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $obsOrder.order.type) {
                        ForEach(Order.types.indices) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(obsOrder.order.quantity)", value: $obsOrder.order.quantity)
                }
                
                Section {
                    Toggle("Any special requests?", isOn: $obsOrder.order.specialReqestEnabled.animation())
                    
                    if obsOrder.order.specialReqestEnabled {
                        Toggle("Add extra frosting", isOn: $obsOrder.order.extraFrosting)
                        
                        Toggle("Add extra sprinkles", isOn: $obsOrder.order.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(obsOrder: obsOrder)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
        }
        .navigationTitle("Cupcake Corner")
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
