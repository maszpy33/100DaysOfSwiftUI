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
    var category: String
    var groupImage: String
    var description: String

    // init modifiedDate with yesterday so getStatus stayes false
//    var modifiedDate = Date(timeIntervalSinceNow: -86500)
    var modifiedDate: Date
    
    var getStatus: Bool = false
//    var getStatus: Bool {
//        guard self.modifiedDate != Date() else {
//            print(self.modifiedDate)
//            print(Date())
//            return true
//        }
//        return false
//    }
    
    var acomplisehedCount: Int = 0 {
        didSet {
            guard self.modifiedDate != Date() else {
                self.modifiedDate = Date()
                return
            }
            
            modifiedDate = Date()
            if acomplisehedCount < 0 {
                acomplisehedCount = 0
            }
        }
    }
}

// habits class to load and save data
class Habits: ObservableObject {
    private static let habitsKey = "habits"
    let formatter = DateFormatter()
    
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
    
    // update getStatus
    func updateGetStatus(task: Task) {
        guard let index = getIndex(task: task) else { return }
        
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        let currentDate = formatter.string(from: Date())
        let modDate = formatter.string(from: tasks[index].modifiedDate)
        
        guard modDate != currentDate else {
            tasks[index].getStatus = true
            return
        }
        tasks[index].getStatus = false
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
