//
//  Habit.swift
//  HabitTracker
//
//  Created by Andreas Zwikirsch on 06.11.21.
//

import Foundation

struct HabitTask: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let groupImage: String
    let description: String
    let todaysDate: Date
    let startDate: Date
    var status: Bool
    var count: Int
    var theme: Int
}

// habits class to load and save data
class Habits: ObservableObject {
    @Published var tasks = [HabitTask]()
    
    
}
