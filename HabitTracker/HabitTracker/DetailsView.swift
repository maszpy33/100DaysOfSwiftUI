//
//  DetailsView.swift
//  HabitTracker
//
//  Created by Andreas Zwikirsch on 06.11.21.
//

import SwiftUI

struct DetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var habits: Habits
    var index: Int
    
    @State private var name = ""
    @State private var newGroupImage = ""
    @State private var newDescription = ""
    @State private var newCategory = ""
    @State private var count = 0
    @State private var modifiedDate = Date()
    
    static let groupImages = ["heart", "mustache", "clock", "person.3.sequence", "pencil", "gamecontroller", "house", "book", "keyboard", "laptopcomputer", "apps.iphone", "apps.ipad", "applewatch", "message", "swift"]
    
    static let categories = ["Bussines", "Private", "Programming", "University", "Art", "Education"]
    
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showAlert = false
    
    let mainColor = Color.orange
    
    var body: some View {
        
        NavigationView {
            List {
                HStack {
                    Label("icon only", systemImage: "calendar")
                        .labelStyle(.iconOnly)
                    Text("Current Date: ")
                    Text(modifiedDate, style: .date)
                }
                
                Picker("Change Icon:", selection: $newGroupImage) {
                    ForEach(Self.groupImages, id: \.self) {
                        Label("icon only", systemImage: $0)
                            .labelStyle(.iconOnly)
                            .foregroundColor(mainColor)
                    }
                }
                
                Picker("Change Category: ", selection: $newCategory) {
                    ForEach(Self.categories, id: \.self) {
                        Text($0)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Change Title:")
                        .frame(alignment: .leading)
                    TextField("\(habits.tasks[index].name)", text: $habits.tasks[index].name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Divider()
                    
                    Text("Change Description:")
                        .frame(alignment: .leading)
                    TextField("\(habits.tasks[index].description)", text: $habits.tasks[index].description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    HStack {
                        Text("Adjust Count: ")
                        Stepper(value: $habits.tasks[index].acomplisehedCount, in: 0...365) {
                            Text("\(habits.tasks[index].acomplisehedCount)")
                        }
                    }
                }
            }
            .navigationBarTitle("DetailsView")
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    guard habits.tasks[index].name != "" else {
                        self.errorTitle = "input error"
                        self.errorMessage = "Your habit has to have a title!"
                        self.showAlert = true
                        return
                    }
                    
                    guard self.newCategory == "" else {
                        habits.tasks[index].category = self.newCategory
                        return
                    }
                    guard self.newGroupImage == "" else {
                        habits.tasks[index].groupImage = self.newGroupImage
                        return
                    }
                    guard self.newDescription == "" else {
                        habits.tasks[index].description = self.newDescription
                        return
                    }
                    

                    self.presentationMode.wrappedValue.dismiss()
                })
            .alert(isPresented: $showAlert) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
//    func changeStatus() {
//        if 
//    }
}

//struct DetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailsView(habits: Habits())
//    }
//}
