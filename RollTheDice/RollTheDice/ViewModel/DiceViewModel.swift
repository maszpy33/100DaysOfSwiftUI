//
//  DiceViewModel.swift
//  RollTheDice
//
//  Created by Andreas Zwikirsch on 19.09.22.
//

import Foundation
import SwiftUI



extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


@MainActor class DiceViewModel: ObservableObject {
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("DiceHistSavePath")
    let dateFormatter = DateFormatter()
    let lavendelColor: Color = Color(red: 177/255, green: 156/255, blue: 217/255)
    let colors = ["blue", "orange", "red", "green", "purple", "white"]
    
    @Published var diceRollList: [Dice]
    @Published var numbCache: [Int] = []
    @Published var diceNumber: Int = 1
    @Published var rollDateTime: Date = Date()
    
    // USERDEFAULT DATA
    @Published var lastRollDateTime: String {
        didSet {
            UserDefaults.standard.set(lastRollDateTime, forKey: "LastTimeRollDiceDateTime")
        }
    }
    
    @Published var themeColorPrimary: String {
        didSet {
            UserDefaults.standard.set(themeColorPrimary, forKey: "ThemeColorPrimary")
        }
    }
    
    @Published var themeColorSecondary: String {
        didSet {
            UserDefaults.standard.set(themeColorSecondary, forKey: "ThemeColorSecondary")
        }
    }
    
    @Published var diceSize: String {
        didSet {
            UserDefaults.standard.set(diceSize, forKey: "DiceSizeKey")
        }
    }
    
    @Published var rounds: String {
        didSet {
            UserDefaults.standard.set(rounds, forKey: "RoundsKey")
        }
    }
    
    @Published var duration: String {
        didSet {
            UserDefaults.standard.set(duration, forKey: "RollDurationKey")
        }
    }
    
    @Published var animationToggle: Bool {
        didSet {
            UserDefaults.standard.set(animationToggle, forKey: "AnimationToggle")
        }
    }
    
    @Published var quickRollToggle: Bool {
        didSet {
            UserDefaults.standard.set(quickRollToggle, forKey: "QuickRollToggle")
        }
    }
    
    @Published var themeSwitch: Bool {
        didSet {
            UserDefaults.standard.set(themeSwitch, forKey: "ThemeSwitch")
        }
    }
    
    
    var primaryAccentColor: Color {
        return changeThemeColor(themeColor: themeColorPrimary)
    }
    
    var secondaryAccentColor: Color {
        return changeThemeColor(themeColor: themeColorSecondary)
    }
    
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            diceRollList = try JSONDecoder().decode([Dice].self, from: data)
        } catch {
            diceRollList = []
        }
        
        self.themeColorPrimary = UserDefaults.standard.object(forKey: "ThemeColorPrimary") as? String ?? "purple"
        self.themeColorSecondary = UserDefaults.standard.object(forKey: "ThemeColorSecondary") as? String ?? "white"
        self.lastRollDateTime = UserDefaults.standard.object(forKey: "LastTimeRollDiceDateTime") as? String ?? "no date yet"
        self.diceSize = UserDefaults.standard.object(forKey: "DiceSizeKey") as? String ?? "6"
        self.rounds = UserDefaults.standard.object(forKey: "RoundsKey") as? String ?? "3"
        self.duration = UserDefaults.standard.object(forKey: "DurationKey") as? String ?? "2"
        self.animationToggle = (UserDefaults.standard.object(forKey: "AnimationToggle")) as? Bool ?? true
        self.quickRollToggle = (UserDefaults.standard.object(forKey: "QuickRollToggle")) as? Bool ?? true
        self.themeSwitch = (UserDefaults.standard.object(forKey: "ThemeSwitch")) as? Bool ?? false
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(diceRollList)
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data: \(error.localizedDescription)")
        }
    }
    
    // DATE FORMAT HELPER FUNCTION
    func formatDate(date: Date) -> String {
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func changeThemeColor(themeColor: String) -> Color {
         switch themeColor {
         case "blue":
             return Color.blue
         case "orange":
             return Color.orange
         case "red":
             return Color.red
         case "green":
             return Color.green
         case "purple":
             return Color.purple
         case "white":
             return Color.white
         default:
             return Color.blue
         }
     }
    
    func quickRollMode() {
        numbCache = []
        let tempDiceSize = (Int(diceSize) ?? 5)+1
        let tempRounds = Int(rounds) ?? 1
        
        for _ in 1..<tempRounds {
            let tempNumb = Int.random(in: 1..<tempDiceSize)
            numbCache.append(tempNumb)
        }
        
        let newDiceRoll = Dice(numbers: numbCache, diceSize: tempDiceSize, rounds: tempRounds, date: Date())
        diceRollList.append(newDiceRoll)
        save()
        numbCache = []
    }
}
