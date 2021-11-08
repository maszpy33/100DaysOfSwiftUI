//
//  AddView.swift
//  HabitTracker
//
//  Created by Andreas Zwikirsch on 06.11.21.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var habits: Habits
    @State private var name = ""
    @State private var groupImage = "person"
    @State private var description = ""
    @State private var category = ""
    @State private var acomplisehedCount = 0
    @State private var modifiedDate = Date()
    
    static let groupImages = ["pills", "heart", "mustache", "clock", "person.3.sequence", "pencil", "gamecontroller", "house", "keyboard", "laptopcomputer", "apps.iphone", "apps.ipad", "applewatch", "message", "swift"]
    
    static let categories = ["Bussines", "Private", "Programming", "University", "Art"]
    
    static let themes: [Color] = [.orange, .red, .green, .blue, .yellow, .purple, .black, .white]
    let themes2: [Color] = [.orange, .red, .green, .blue, .yellow, .purple, .black, .white]
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showAlert = false
    
    let mainColor = Color.orange
    
    
    var body: some View {
        
        NavigationView {
            List {

                DatePicker("Start Date:", selection: $modifiedDate, displayedComponents: .date)
                
                Picker("Habit Image:", selection: $groupImage) {
                    ForEach(Self.groupImages, id: \.self) {
                        Label("icon only", systemImage: $0)
                            .labelStyle(.iconOnly)
                    }
                }
                
                Picker("Category: ", selection: $category) {
                    ForEach(Self.categories, id: \.self) {
                        Text($0)
                            .foregroundColor(mainColor)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Title:")
                        .frame(alignment: .leading)
                    TextField("", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Divider()
                    
                    Text("Description:")
                        .frame(alignment: .leading)
                    TextField("", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

//                    Picker("Change Theme:", selection: $theme) {
//                        ForEach(Self.themes, id: \.self) { color in
//                            Label("icon only", systemImage: self.groupImage)
//                                .labelStyle(.iconOnly)
//                                .foregroundColor(color)
//                        }
//                    }
//                    .foregroundColor(currentTheme)
                }
            }
            .foregroundColor(mainColor)
            .navigationBarTitle("Add new habit")
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    guard self.name != "" else {
                        self.errorTitle = "input error"
                        self.errorMessage = "Your habit has to have a title!"
                        self.showAlert = true
                        return
                    }
                    
                    let task = Task(name: self.name, category: self.category, groupImage: self.groupImage, description: self.description, modifiedDate: self.modifiedDate, acomplisehedCount: self.acomplisehedCount)
                    
                    self.habits.tasks.append(task)
                    self.presentationMode.wrappedValue.dismiss()
                })
            .alert(isPresented: $showAlert) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
//    func raisCount() {
//        if self.status {
//            self.count += 1
//        }
//    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(habits: Habits()).preferredColorScheme(.dark)
    }
}
