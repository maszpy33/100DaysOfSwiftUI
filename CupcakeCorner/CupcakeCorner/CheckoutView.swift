//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Andreas Zwikirsch on 20.11.21.
//

import SwiftUI


// Challenge 2
enum AlertType {
    case confirmation
    case error
}

struct CheckoutView: View {
    @ObservedObject var obsOrder: ObservableOrder
    
    // Challenge 2
    @State private var showingAlert = false
    @State private var confirmationMessage = ""
    @State private var errorMessage = ""
    @State private var alertType = AlertType.confirmation
    
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
                
                Text("Your total is \(obsOrder.order.cost, format: .currency(code: "EUR"))")
                    .font(.title)
                
                Button("Place Order", action: {
                    Task {
                        await placeOrder()
                    }
                })
                    .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingAlert) { () -> Alert in
            switch alertType {
            case .confirmation:
                return Alert(title: Text("Thank you!"), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
            case .error:
                return Alert(title: Text("Error!"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(obsOrder.order) else {
            print("Failed to encode order")
            self.showingAlert = true
            return
        }
        
        // ! if we would get back a nil -> the app crashes
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            self.showAlert(confirmation: confirmationMessage)
        } catch {
            print("Checkout failed.")
            // Challenge 2
            self.showAlert(error: "Connction failed, please try again")
        }
    }
    
    // Challenge 2
    func showAlert(confirmation: String) {
        self.confirmationMessage = confirmation
        self.alertType = .confirmation
        self.showingAlert = true
    }
    
    // Challenge 2
    func showAlert(error: String) {
        self.errorMessage = error
        self.alertType = .error
        self.showingAlert = true
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(obsOrder: ObservableOrder(order: Order()))
    }
}
