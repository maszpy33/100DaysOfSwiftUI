//
//  Person.swift
//  NameList
//
//  Created by Andreas Zwikirsch on 31.07.22.
//

import Foundation

struct Person: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    
}
