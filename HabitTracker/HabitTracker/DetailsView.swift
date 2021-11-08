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
    @State private var groupImage = "person"
    @State private var description = ""
    @State private var category = ""
    @State private var count = 0
    @State private var modifiedDate = Date()
    
    static let groupImages = ["pills", "heart", "mustache", "clock", "person.3.sequence", "pencil", "gamecontroller", "house", "keyboard", "laptopcomputer", "apps.iphone", "apps.ipad", "applewatch", "message", "swift"]
    
    static let categories = ["Bussines", "Private", "Programming", "University", "Art"]
    
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showAlert = false
    
    
    var body: some View {
        
        NavigationView {
            List {

//                Text("\(taskTitle)")
                
                Label("Last Modified: \(modifiedDate)", systemImage: "calendar")
                
                Picker("Change Icon:", selection: $groupImage) {
                    ForEach(Self.groupImages, id: \.self) {
                        Label("icon only", systemImage: $0)
                            .labelStyle(.iconOnly)
                    }
                }
                
                // EDIT: user can add a category name
                Picker("Change Category: ", selection: $category) {
                    ForEach(Self.categories, id: \.self) {
                        Text($0)
                            .foregroundColor(.orange)
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
                    TextField("", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    HStack {
                        Text("Adjust Count: ")
                        Stepper(value: $habits.tasks[index].acomplisehedCount, in: 0...365) {
                            Text("\(habits.tasks[index].acomplisehedCount)")
                        }
                    }
                }
            }
            .foregroundColor(.orange)
            .navigationBarTitle("DetailsView")
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    
                    // FIXME: saving only creates a new habit with the new name
                    guard habits.tasks[index].name != "" else {
                        self.errorTitle = "input error"
                        self.errorMessage = "Your habit has to have a title!"
                        self.showAlert = true
                        return
                    }
//                    let task = Task(name: self.name, category: self.category, groupImage: self.groupImage, description: self.description, modifiedDate: self.modifiedDate, acomplisehedCount: self.acomplisehedCount)
                    
//                    self.habits.tasks.append(task)
                    self.presentationMode.wrappedValue.dismiss()
                })
            .alert(isPresented: $showAlert) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

//struct DetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailsView(habits: Habits())
//    }
//}
