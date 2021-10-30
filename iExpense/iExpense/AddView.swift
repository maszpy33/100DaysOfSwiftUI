//
//  AddView.swift
//  iExpense
//
//  Created by Andreas Zwikirsch on 28.10.21.
//

import SwiftUI

// challenge 3
extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}


struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var spendOnDate = Date()
    static let types = ["Bussines", "Personal", "Tech", "Office", "Groceries"]
    
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date of expense:", selection: $spendOnDate, displayedComponents: .date)
                
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Name", text: $name) 
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
                        guard self.name != "" else {
                            self.errorTitle = "input error"
                            self.errorMessage = "Pleace enter the name of your expense"
                            self.showAlert = true
                            return
                        }
                        guard self.amount != "" else {
                            self.errorTitle = "input error"
                            self.errorMessage = "Pleace enter the costs of your expense"
                            self.showAlert = true
                            return
                        }
                        
                        guard self.amount.isInt else {
                            self.errorTitle = "input error"
                            self.errorMessage = "\(self.amount) is not an integer"
                            self.showAlert = true
                            self.amount = ""
                            return
                        }
                        
                        let actualAmount = Int(self.amount)!
                        let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount, spendOnDate: self.spendOnDate)
                        self.expenses.items.append(item)
                        self.presentationMode.wrappedValue.dismiss()
                    })
            // Challenge 3
            .alert(isPresented: $showAlert) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses()).preferredColorScheme(.dark)
    }
}

