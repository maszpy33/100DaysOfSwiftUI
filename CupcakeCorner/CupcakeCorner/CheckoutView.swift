//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Andreas Zwikirsch on 20.11.21.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    
    @State private var animationGo = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total is \(order.cost, format: .currency(code: "EUR"))")
                    .font(.title)
                
                Button("Place Order", action: {
                    self.animationGo.toggle()
                })
                    .padding()
                
                Text("🧁")
                    .opacity(self.animationGo ? 1 : 0)
                    .scaleEffect(self.animationGo ? 4 : 1)
                    .offset(x: 0, y: self.animationGo ? 400 : 0)
                    .animation(.easeIn)
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
