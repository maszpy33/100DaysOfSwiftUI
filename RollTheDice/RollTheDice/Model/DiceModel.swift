//
//  dice.swift
//  RollTheDice
//
//  Created by Andreas Zwikirsch on 19.09.22.
//

import Foundation


struct Dice: Identifiable, Codable {
    let id = UUID().uuidString
    let numbers: [Int]
    let diceSize: Int
    let rounds: Int
    let date: Date
    
    static let sampleDice = Dice(numbers: [2, 4, 5, 6], diceSize: 6, rounds: 4, date: Date())
}
