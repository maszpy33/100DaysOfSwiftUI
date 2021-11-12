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
    @State private var getStatus = false
    
    static let groupImages = ["heart", "mustache", "clock", "person.3.sequence", "pencil", "gamecontroller", "house", "book", "keyboard", "laptopcomputer", "apps.iphone", "apps.ipad", "applewatch", "message", "swift", "tortoise"]
    
    static let categories = ["Bussines", "Private", "Programming", "University", "Art"]
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showAlert = false
    
    let mainColor = Color.orange
    
    
    var body: some View {
        
        NavigationView {
            List {
//                DatePicker("Current Date:", selection: $modifiedDate, displayedComponents: .date)
                HStack {
                    Text("Last modified Date:")
                    Text(modifiedDate, style: .date)
                }
                
                Picker("Habit Icon:", selection: $groupImage) {
                    ForEach(Self.groupImages, id: \.self) {
                        Label("icon only", systemImage: $0)
                            .labelStyle(.iconOnly)
                            .foregroundColor(mainColor)
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

                }
            }
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
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(habits: Habits()).preferredColorScheme(.dark)
    }
}
