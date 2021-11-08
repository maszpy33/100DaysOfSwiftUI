//
//  ContentView.swift
//  HabitTracker
//
//  Created by Andreas Zwikirsch on 06.11.21.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("today") var nameAno = "anonymous"
    
    @ObservedObject var habits = Habits()
    @State private var showingDetailsView = false
    @State private var showingAddView = false
    
    static let taskDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    let mainColor = Color.orange
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits.tasks.indices, id: \.self) { index in
                    NavigationLink(destination: DetailsView(index: index).environmentObject(self.habits)) {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Label("icon only", systemImage: self.habits.tasks[index].getStatus ? "checkmark.circle" : "xmark.circle")
                                        .labelStyle(.iconOnly)
                                        .foregroundColor(self.habits.tasks[index].getStatus ? .green : .red)
                                    Text(self.habits.tasks[index].name)
                                        .font(.headline)
                                    Text(" |  Habit Count: \(self.habits.tasks[index].acomplisehedCount)")
                                }
                                HStack {
                                    Label("icon only", systemImage: self.habits.tasks[index].groupImage)
                                        .labelStyle(.iconOnly)
                                        .foregroundColor(mainColor)
                                    Text(self.habits.tasks[index].category)
                                }
                                .padding(5)
                            }
                        }
                        .font(.subheadline)
                    }
                    
                }
                .onDelete(perform: removeTask)
            }
            .listStyle(GroupedListStyle())
            .onAppear(perform: updateGetStatus)
            .navigationBarTitle("HabitTracker: \(nameAno)")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    self.showingAddView = true
                }) {
                    Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddView) {
                AddView(habits: self.habits)
            }
        }
    }
    
    func removeTask(at offsets: IndexSet) {
        habits.tasks.remove(atOffsets: offsets)
    }
    
    func updateGetStatus() {
        for ind in 0..<self.habits.tasks.count {
            habits.updateGetStatus(index: ind)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
