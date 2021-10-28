//
//  AddView.swift
//  iExpense
//
//  Created by Andreas Zwikirsch on 28.10.21.
//

import SwiftUI

// challenge 3
extension String {
    var isStringInt: Bool {
        return Int(self) != nil
    }
}


struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    static let types = ["Bussines", "Personal"]
    
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(
                leading:
                    Button("Cancel") {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                trailing:
                    Button("Save") {
                // challenge 3
                if self.amount.isStringInt {
                    if let actualAmount = Int(self.amount) {
                        
                        let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                        self.expenses.items.append(item)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    // Challenge 3
//                    errorTitle = "Input Error"
//                    errorMessage = "Not a Integer"
                    self.amountError(title: "Input Error", message: "Not an Integer")
                    self.showAlert = true
                }

            })
            // Challenge 3
            .alert(isPresented: $showAlert) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // Challenge 3
    func amountError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showAlert = true
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}

