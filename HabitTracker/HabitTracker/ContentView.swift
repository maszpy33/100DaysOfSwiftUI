//
//  ContentView.swift
//  HabitTracker
//
//  Created by Andreas Zwikirsch on 06.11.21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var habits = Habits()
    @State private var showingDetailsView = false
    @State private var showingAddView = false
    
    static let taskDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits.tasks) { habit in
                    NavigationLink(destination: DetailsView(habits: self.habits, taskTitle: habit.name)) {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Label("icon only", systemImage: habit.getStatus ? "checkmark.circle" : "xmark.circle")
                                        .labelStyle(.iconOnly)
                                        .foregroundColor(habit.getStatus ? .green : .red)
                                    Text(habit.name)
                                        .font(.headline)
                                    Text(" | Count: \(habit.count)")
                                }
                                HStack {
                                    Label("icon only", systemImage: habit.groupImage)
                                        .labelStyle(.iconOnly)
                                    Text(habit.category)
                                }
                            }
                        }
                        .font(.subheadline)
                    }
                    
                }
                .onDelete(perform: removeTask)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("HabitTracker:")
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
