//
//  Habit.swift
//  HabitTracker
//
//  Created by Andreas Zwikirsch on 06.11.21.
//

import Foundation

struct Task: Identifiable, Codable {
    let id = UUID()
    var name: String
    let category: String
    let groupImage: String
    let description: String
    var modifiedDate = Date()
    
    var count: Int = 0 {
        didSet {
            modifiedDate = Date()
            if count < 0 {
                count = 0
            }
        }
    }
    
    var getStatus: Bool {
        guard modifiedDate == Date() else {
            return false
        }
        return true
    }
}

// habits class to load and save data
class Habits: ObservableObject {
    private static let habitsKey = "habits"
    
    @Published var tasks = [Task]() {
        didSet {
            // save date each time the content of the array is modified:
            // add, remove, but also when modifying an element of the array
            if let encode = try? JSONEncoder().encode(tasks) {
                UserDefaults.standard.set(encode, forKey: Self.habitsKey)
            }
        }
    }
    
    init() {
        if let encoded = UserDefaults.standard.data(forKey: Self.habitsKey) {
            if let decoded = try? JSONDecoder().decode([Task].self, from: encoded) {
                self.tasks = decoded
                return
            }
        }
        
        self.tasks = []
    }
    
    // add helper functions
    func add(task: Task) {
        tasks.append(task)
        // add sort tasks by date function
    }
    
    // sort by date function to come later
    
    func update(task: Task) {
        guard let index = getIndex(task: task) else { return }
        
        tasks[index] = task
    }
    
    // get index by Task
    private func getIndex(task: Task) -> Int? {
        return tasks.firstIndex(where: { $0.id == task.id })
    }
    
    // get index by UUID
    private func getIndex(id: UUID) -> Int? {
        return tasks.firstIndex(where: { $0.id == id })
    }
}
