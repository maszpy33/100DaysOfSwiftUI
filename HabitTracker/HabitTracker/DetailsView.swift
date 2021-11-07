//
//  DetailsView.swift
//  HabitTracker
//
//  Created by Andreas Zwikirsch on 06.11.21.
//

import SwiftUI

struct DetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var habits: Habits
    @State var taskTitle: String
    
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
                    TextField("\(taskTitle)", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Divider()
                    
                    Text("Change Description:")
                        .frame(alignment: .leading)
                    TextField("", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
//                    Toggle(isOn: $status) {
//                        Text("Habit Switch")
//                            .font(.headline)
//                            .foregroundColor(currentTheme)
//                    }
//                    .toggleStyle(SwitchToggleStyle(tint: currentTheme))
//                    .onChange(of: status) { _status in
//                        if _status {
//                            self.count += 1
//                        }
//                    }
//                    .shadow(color: currentTheme.opacity(0.2), radius: 3, x: 0.0, y: 0.0)
//
                    HStack {
                        Text("Adjust Count: ")
                        Stepper(value: $count, in: 0...365) {
                            Text("\(count)")
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
                    guard self.name != "" else {
                        self.name = taskTitle
                        return
                    }
                    
                    let task = Task(name: self.name, category: self.category, groupImage: self.groupImage, description: self.description, modifiedDate: self.modifiedDate, count: self.count)
                    
                    self.habits.tasks.append(task)
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
