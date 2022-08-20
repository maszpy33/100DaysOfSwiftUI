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
    @Published var people: [Prospect]
    
    init() {
        people = [] 
    }
    
    // without this function when a value of an element of the people array
    // out view would not be updatetd. So we have to trigger it with this func
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
    }
}
