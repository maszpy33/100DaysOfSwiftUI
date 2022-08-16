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
    var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published var people: [Prospect]
    
    init() {
        people = [] 
    }
}
