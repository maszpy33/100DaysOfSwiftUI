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
                .opacity(0.5)
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

struct DefaultFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 28))
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
    }
}

// Button Style
struct ButtonDefault: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .shadow(color: .black, radius: 8)
            .background(Color.white)
            .clipShape(Circle())
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
    
    func defaultFont() -> some View {
        self.modifier(DefaultFont())
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
    let symbols = ["✊", "✋", "✌️"]
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
                
                Picker("Difficulty Level | Current:", selection: $difficultyLevel) {
                    ForEach(0..<difficulties.count) {
                        Text("\(self.difficulties[$0])")
                    }
                }
                
                Section {
                    Label("Bots choice: \(self.choices[botChoice])", systemImage: "brain")
                        .foregroundColor(.white)
                        .defaultFont()
                    
                    Text("\(symbols[botChoice])")
                        .font(.system(size: 70))
                        .padding()
                        .shadow(color: .black, radius: 8)
                        .background(Color.white)
                        .clipShape(Circle())
                    
                    HStack(spacing: 30){
                        VStack {
                            Text("You have to:")
                                .bold()
                            Text("\(goals[goalChoice])")
                                .font(.system(size: 25))
                                .foregroundColor(.blue)
                        }
                        
                        // Timer
                        VStack {
                            Text("Time left: ")
                                .foregroundColor(.white)
                                .bold()
                            HStack(spacing: 10){
                                Image(systemName: "clock.fill")
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
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
                
                
                
                Section {
                    Text("Make your choise")
                        //                        .font(.system(size: 30))
                        .defaultFont()
                    
                    HStack {
                        Section {
                            // User Choice Buttons
                            Button(action: {
                                self.gameStart = false
                                // check if user made the correct choice
                                correctUserChoice = Winner(userChoice: 0, botChoice: botChoice)
                                if correctUserChoice == true {
                                    alertTitle = "Winner!"
                                    alertText = "Nice! Your brain knows no limits!\n🧠"
                                } else {
                                    alertTitle = "Loser"
                                    alertText = "Your goal was: \(goals[goalChoice])...!"
                                }
                                showResult = true
                            }) {
                                Text("\(symbols[0])")
                            }
                            .buttonStyle(ButtonDefault())
                            
                            Button(action: {
                                self.gameStart = false
                                // check if user made the correct choice
                                correctUserChoice = Winner(userChoice: 1, botChoice: botChoice)
                                if correctUserChoice == true {
                                    alertTitle = "Winner!"
                                    alertText = "Nice! Your brain knows no limits!\n🧠"
                                } else {
                                    alertTitle = "Loser"
                                    alertText = "Your goal was: \(goals[goalChoice])...!"
                                }
                                showResult = true
                            }) {
                                Text("\(symbols[1])")
                            }
                            .buttonStyle(ButtonDefault())
                            
                            Button(action: {
                                self.gameStart = false
                                // check if user made the correct choice
                                correctUserChoice = Winner(userChoice: 2, botChoice: botChoice)
                                if correctUserChoice == true {
                                    alertTitle = "Winner!"
                                    alertText = "Nice! Your brain knows no limits!\n🧠"
                                } else {
                                    alertTitle = "Loser"
                                    alertText = "Your goal was: \(goals[goalChoice])...!"
                                }
                                showResult = true
                            }) {
                                Text("\(symbols[2])")
                            }
                            .buttonStyle(ButtonDefault())
                        }
                    }
                    .font(.system(size: 70))
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
                
                Section {
                    Button(action: {
                        // set time according to difficutlyLevel
                        // and let bot + user goal random select
                        self.timeRemaining = difficultyLevelTime
                        self.botChoice = Int.random(in: 0..<choices.count)
                        self.goalChoice = Int.random(in: 0..<goals.count)
                        
                        self.gameStart = true
                    }) {
                        HStack {
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .overlay(Capsule().stroke(Color.black, lineWidth: 2))
                            //                                .shadow(color: .black, radius: 8)
                            Text("Start")
                                .bold()
                                .font(.system(size: 30))
                        }
                        .padding()
                    }
                    .foregroundColor(.green)
                    .buttonStyle(BorderlessButtonStyle())
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
            }
            .alert(isPresented: $showResult) {
                Alert(title: Text(alertTitle), message: Text(alertText), dismissButton: .default(Text("Continue")) {
                })
            }
            .watermarked(with: "Made by Zwitschki")
            .navigationBarTitle("Rock-Paper-Scissors")
            
        }
    }
    
    func Winner(userChoice: Int, botChoice: Int) -> Bool {
        
        // Draw
        if goals[goalChoice] == "Draw" {
            if choices[userChoice] == choices[botChoice] {
                return true
            }
            
            // Win
        } else if goals[goalChoice] == "Win" {
            if choices[userChoice] == "Rock" && choices[botChoice] == "Scissors" {
                return true
            } else if choices[userChoice] == "Paper" && choices[botChoice] == "Rock" {
                return true
            } else if choices[userChoice] == "Scissors" && choices[botChoice] == "Paper" {
                return true
            }
            
            // Lose
        } else if goals[goalChoice] == "Lose" {
            if choices[userChoice] == "Rock" && choices[botChoice] == "Scissors" {
                return false
            } else if choices[userChoice] == "Paper" && choices[botChoice] == "Rock" {
                return false
            } else if choices[userChoice] == "Scissors" && choices[botChoice] == "Paper" {
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
