//
//  Prospect.swift
//  HotProspects
//
//  Created by Andreas Zwikirsch on 16.08.22.
//

import Foundation

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    let saveKey = "SavedData"
    let saveKeyFileManager = "SavedProspects"
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedProspects")
    
    init() {
//        if let data = UserDefaults.standard.data(forKey: saveKey) {
//            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
//                people = decoded
//                return
//            }
//        }
//        people = [] 
        
        do {
            let data = try Data(contentsOf: savePath)
            people = try JSONDecoder().decode([Prospect].self, from: data)
        } catch {
            people = []
        }
    }
    
    // private so save func is only callabel from iside the class
//    private func save() {
//        if let encoded = try? JSONEncoder().encode(people) {
//            UserDefaults.standard.set(encoded, forKey: saveKey)
//        }
//    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(people)
            // .completeFileProtection encryptes the data
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("####################")
            print("Unable to save data")
            print("####################")
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    // without this function when a value of an element of the people array
    // out view would not be updatetd. So we have to trigger it with this func
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        
        save()
    }
}
