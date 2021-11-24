//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Andreas Zwikirsch on 20.11.21.
//

import SwiftUI

struct AddressView: View {
    // Challenge 3
    @ObservedObject var obsOrder: ObservableOrder
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $obsOrder.order.name)
                TextField("Street Address", text: $obsOrder.order.streetAddress)
                TextField("City", text: $obsOrder.order.city)
                TextField("Zip", text: $obsOrder.order.zip)
            }
            
            Section {
                NavigationLink {
                    CheckoutView(obsOrder: obsOrder)
                } label: {
                    Text("Check out")
                }
            }
            .disabled(obsOrder.order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddressView(obsOrder: ObservableOrder(order: Order()))
        }
    }
}
