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
        
        List {
            
            Toggle(isOn: $status) {
                Text("Habit Switch")
                    .font(.headline)
                    .foregroundColor(currentTheme)
            }
            .toggleStyle(SwitchToggleStyle(tint: currentTheme))
            .onChange(of: status) { _status in
                if _status {
                    self.count += 1
                }
            }
            .shadow(color: currentTheme.opacity(0.2), radius: 3, x: 0.0, y: 0.0)
            
            HStack {
                Text("Adjust Count: ")
                Stepper(value: $count, in: 0...365) {
                    Text("\(count)")
                }
            }
            
            Picker("Change Theme:", selection: $theme) {
                ForEach(Self.themes, id: \.self) { color in
                    Label("icon only", systemImage: self.groupImage)
                        .labelStyle(.iconOnly)
                        .foregroundColor(color)
                }
            }
            .foregroundColor(currentTheme)
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Details View:")
        .navigationBarItems(
            leading: Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            },
            trailing: Button("Save") {
                let task = HabitTask(name: self.name, category: self.category, groupImage: self.groupImage, description: self.description, todaysDate: self.todaysDate, startDate: self.startDate, status: self.status, count: self.count, theme: self.theme)
                self.habits.tasks.append(task)
                self.presentationMode.wrappedValue.dismiss()
            })
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(habits: Habits())
    }
}
