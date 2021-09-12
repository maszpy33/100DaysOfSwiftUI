//
//  ContentView.swift
//  RockPaperScissorsReverse
//
//  Created by Andreas Zwikirsch on 11.09.21.
//

import SwiftUI

// Modifier
struct Watermark: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
        }
    }
}

struct RPSView: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.white, .black]), center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, startRadius: 10, endRadius: 60)
            content
                .font(.system(size: 60))
                .foregroundColor(.white)
        }
        
    }
}


// extensions
extension View {
    func watermarked(with text: String) -> some View {
        self.modifier(Watermark(text: text))
    }
    
    func rpsview() -> some View {
        self.modifier(RPSView())
    }
}

extension Image {
    func imageFormat() -> some View {
        self
            .resizable()
            .frame(width: 100, height: 100)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

// ContentView
struct ContentView: View {
    let choices = ["Rock", "Paper", "Scissors"]
    let symbols = ["🪨", "🍃", "✂️"]
    let choicesDict = ["Rock": "🪨", "Paper": "🍃", "Scissor": "✂️"]
    let goals = ["Win", "Lose", "Draw"]
    
    @State private var goalChoice = Int.random(in: 0...2)
    @State private var botChoice = 0
    @State private var userChoice = 1
    
    @State private var showResult = false
    @State private var correctUserChoice = false
    
    @State private var alertTitle = ""
    @State private var alertText = ""
    
    // timer properties
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = 5
    @State private var gameStart = false
    
    // Difficulti Level
    let difficulties = ["Easy", "Medium", "Hard", "Insane"]
    @State private var difficultyLevel = 1
    
    var difficultyLevelTime: Int {
        if difficultyLevel == 0 {
            return 10
        } else if difficultyLevel == 1 {
            return 7
        } else if difficultyLevel == 2 {
            return 5
        } else if difficultyLevel == 3 {
            return 2
        }
        return 0
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                
                Picker("Difficulty Level:", selection: $difficultyLevel) {
                    ForEach(0..<difficulties.count) {
                        Text("\(self.difficulties[$0])")
                    }
                }
                
                Section {
                    Label("Bots choice: \(self.choices[botChoice])", systemImage: "brain")
                        .foregroundColor(.white)
                        .font(.title)
                    
                    HStack(spacing: 20){
                        Text("Bot choice:")
                            .bold()
                            .foregroundColor(.red)
                        Image(self.choices[botChoice])
                            .imageFormat()
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
                
                Section {
                    HStack(spacing: 20){
                        Text("User Choice:")
                            .bold()
                            .foregroundColor(.blue)
                        Image(choices[userChoice])
                            .imageFormat()
                    }
                    
                    // Timer
                    HStack {
                        Label("Time left: ", systemImage: "clock.fill")
                            .foregroundColor(.white)
                        Text("\(timeRemaining)s")
                            .onReceive(timer) { _ in
                                if self.gameStart == true {
                                    if timeRemaining > 0 {
                                        timeRemaining -= 1
                                    } else if timeRemaining <= 0 && showResult == false {
                                        self.gameStart = false
                                        correctUserChoice = false
                                        alertTitle = "To slow.."
                                        alertText = "Next time, think faster!\nLoser!"
                                        showResult = true
                                    } else if showResult == true {
                                        timeRemaining = difficultyLevelTime
                                    }
                                }
                            }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
                
                Section {
                    HStack(spacing: 20) {
                        Section {
                            VStack {
                                Text("Current user goal:")
                                Text("\(goals[goalChoice])")
                                    .foregroundColor(.blue)
                                    .font(.title)
                            }
                        }
                        
                        Section {
                            // Play Button
                            Button(action: {
                                // set time according to difficutlyLevel
                                // and let bot + user goal random select
                                self.timeRemaining = difficultyLevelTime
                                self.botChoice = Int.random(in: 0..<choices.count)
                                self.goalChoice = Int.random(in: 0..<goals.count)
                                
                                self.gameStart = true
                            }) {
                                VStack {
                                    Image(systemName: "play.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .overlay(Capsule().stroke(Color.black, lineWidth: 2))
                                        .shadow(color: .black, radius: 8)
                                    Text("Start")
                                }
                            }
                            .foregroundColor(.green)
                            .buttonStyle(BorderlessButtonStyle())
                            
                            // Stop Button
                            Button(action: {
                                
                                if self.gameStart == false {
                                    // reset time if time is already stopped
                                    self.timeRemaining = difficultyLevelTime
                                    self.showResult = false
                                    
                                } else {
                                    self.gameStart = false
                                    // check if user made the correct choice
                                    correctUserChoice = Winner(userChoice: userChoice, botChoice: botChoice)
                                    if correctUserChoice == true {
                                        alertTitle = "Winner!"
                                        alertText = "Nice! Your brain knows no limits!\n🧠"
                                    } else {
                                        alertTitle = "Loser"
                                        alertText = "Your goal was: \(goals[goalChoice])...!"
                                    }
                                    showResult = true
                                }
                            }) {
                                VStack {
                                    Image(systemName: "play.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .overlay(Capsule().stroke(Color.black, lineWidth: 2))
                                        .shadow(color: .black, radius: 8)
                                    Text("Stop")
                                }
                                
                            }
                            .foregroundColor(.red)
                            .buttonStyle(BorderlessButtonStyle())
                            
                            
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
                    
                    Text("User choice:")
                        .frame(alignment: .center)
                    
                    Picker("Make your choice:", selection: $userChoice) {
                        ForEach(0..<choices.count) {
                            Text("\(self.choices[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
            }
            .alert(isPresented: $showResult) {
                Alert(title: Text(alertTitle), message: Text(alertText), dismissButton: .default(Text("Continue")) {
                })
            }
            .watermarked(with: "Made by Zwitschki")
            .navigationBarTitle("Rock-Paper-Scissors")
        }
    }
    
    //    func AlertType() -> (String, String) {
    //        self.alertTitle = "Lose"
    //        self.alertText = "Win"
    //    }
    
    // return true if user made the right choice
    func Winner(userChoice: Int, botChoice: Int) -> Bool {
        
        // Draw
        if goals[goalChoice] == "Draw" {
            if choices[userChoice] == choices[botChoice] {
                return true
            }
            
            // Win
        } else if goals[goalChoice] == "Win" {
            if choices[userChoice] == "Rock" && choices[botChoice] == "Scissor" {
                return true
            } else if choices[userChoice] == "Paper" && choices[botChoice] == "Rock" {
                return true
            } else if choices[userChoice] == "Scissor" && choices[botChoice] == "Paper" {
                return true
            }
            
            // Lose
        } else if goals[goalChoice] == "Lose" {
            if choices[userChoice] == "Rock" && choices[botChoice] == "Scissor" {
                return false
            } else if choices[userChoice] == "Paper" && choices[botChoice] == "Rock" {
                return false
            } else if choices[userChoice] == "Scissor" && choices[botChoice] == "Paper" {
                return false
            } else {
                return true
            }
        }
        return false
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}
