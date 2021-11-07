//
//  AddView.swift
//  HabitTracker
//
//  Created by Andreas Zwikirsch on 06.11.21.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var habitDetail: Habits
    @State private var name = ""
    @State private var groupImage = "person"
    @State private var description = ""
    @State private var todaysDate = Date()
    @State private var category = ""
    @State private var count = 0
    @State private var status = false
    @State private var theme = 0
    @State private var startDate = Date()
    
    static let groupImages = ["pills", "heart", "mustache", "clock", "person.3.sequence", "pencil", "gamecontroller", "house", "keyboard", "laptopcomputer", "apps.iphone", "apps.ipad", "applewatch", "message", "swift"]
    
    static let categories = ["Bussines", "Private", "Programming", "University", "Art"]
    
    static let themes: [Color] = [.orange, .red, .green, .blue, .yellow, .purple, .black, .white]
    let themes2: [Color] = [.orange, .red, .green, .blue, .yellow, .purple, .black, .white]
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showAlert = false
    
    
    var body: some View {
        var currentTheme = themes2[theme]
        
        NavigationView {
            List {
                DatePicker("Start Date:", selection: $startDate, displayedComponents: .date)
                
                Picker("Habit Image:", selection: $groupImage) {
                    ForEach(Self.groupImages, id: \.self) {
                        Label("icon only", systemImage: $0)
                            .labelStyle(.iconOnly)
                    }
                }
                
                // EDIT: user can add a category name
                Picker("Category: ", selection: $category) {
                    ForEach(Self.categories, id: \.self) {
                        Text($0)
                            .foregroundColor(currentTheme)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Title:")
                        .frame(alignment: .leading)
                    TextField("", text: $name)
                        .background(Color(red: 0.4, green: 0.4, blue: 0.4))
                    
                    Divider()
                    
                    Text("Description:")
                        .frame(alignment: .leading)
                    TextField("", text: $description)
                        .background(Color(red: 0.4, green: 0.4, blue: 0.4))
                    
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
//                    HStack {
//                        Text("Adjust Count: ")
//                        Stepper(value: $count, in: 0...365) {
//                            Text("\(count)")
//                        }
//                    }
//
                    Picker("Change Theme:", selection: $theme) {
                        ForEach(Self.themes, id: \.self) { color in
                            Label("icon only", systemImage: self.groupImage)
                                .labelStyle(.iconOnly)
                                .foregroundColor(color)
                        }
                    }
                    .foregroundColor(currentTheme)
                }
            }
            .foregroundColor(currentTheme)
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
                    
                    let task = HabitTask(name: self.name, category: self.category, groupImage: self.groupImage, description: self.description, todaysDate: self.todaysDate, startDate: self.startDate, status: self.status, count: self.count, theme: self.theme)
                    self.habits.tasks.append(task)
                    self.presentationMode.wrappedValue.dismiss()
                })
            .alert(isPresented: $showAlert) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func raisCount() {
        if self.status {
            self.count += 1
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(habits: Habits()).preferredColorScheme(.dark)
    }
}
