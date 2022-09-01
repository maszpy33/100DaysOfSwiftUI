//
//  Card.swift
//  Flashzilla
//
//  Created by Andreas Zwikirsch on 01.09.22.
//

import Foundation


struct Card {
    let prompt: String
    let answer: String
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
