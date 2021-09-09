//
//  ContentView.swift
//  TapTheBug
//
//  Created by Andreas Zwikirsch on 08.09.21.
//

import SwiftUI

struct ContentView: View {
    @State private var bugCounter = 0
    @State private var bugDeath = false
    @State private var showingAlert = false
    @State private var bugHealth = Int.random(in: 25...45)
    
    
    @State var gameStart = false
    @State var timeRemaining = 10
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let difficulties = ["Easy", "Medium", "Hard", "Insane"]
    @State private var difficultyLevel = 1
    
    var bugLevel: Int {
        if difficultyLevel == 0 {
            // easy
            bugHealth = Int.random(in: 5...25)
        } else if difficultyLevel == 1 {
            // medium
            bugHealth = Int.random(in: 25...45)
        } else if difficultyLevel == 2 {
            // hard
            bugHealth = Int.random(in: 45...65)
        } else if difficultyLevel == 3 {
            // insane
            bugHealth = Int.random(in: 65...150)
        }

        return bugHealth
    }
    
    
    
    var body: some View {
        let bugHealthBar = bugLevel
        
        NavigationView {
            Form {
                Section (header: Text("Can you beat the bug?!").bold().padding()){
                    Button("Instructions") {
                        self.showingAlert = true
                    }.alert(isPresented: $showingAlert) {
                        Alert(title: Text("Hello Bug-Destroyer"),
                              message: Text("Tap the bug as fast as you can!"),
                              dismissButton: .default(Text("OK")))
                    }
                    
                    Text("Choose your skill level:")
                    Picker("Start Unit", selection: $difficultyLevel) {
                        ForEach(0..<difficulties.count) {
                            Text("\(self.difficulties[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Button("Reset") {
                        self.bugHealth = Int.random(in: 15...50)
                        self.bugCounter = 0
                        bugDeath = false
                        timeRemaining = 10
                        self.gameStart = false
                        bugHealth = bugLevel
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
                
                Section {
                    Text("Time is running!")
                    Text("\(timeRemaining)s")
                        .onReceive(timer) { _ in
                            if self.gameStart == true {
                                if timeRemaining > 0 {
                                    timeRemaining -= 1
                                }
                            } else if bugDeath == true {
                                self.gameStart = false
                            }
                            
                        }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
                
                Section {
                  
                    Text("Bug taps \(bugCounter) | Bug health \(bugHealthBar-bugCounter)")

                    
                    if self.bugDeath == false && self.timeRemaining > 0{
                        Button(action: {
                            print("Bug was tapped!")
                            if self.bugCounter < bugHealthBar {
                                self.bugCounter += 1
//                                bugHealthBar -= 1
                                if self.bugCounter == 1 {
                                    gameStart = true
                                }
                            } else {
                                self.bugDeath = true
                                self.gameStart = false
                            }
                        }) {
                            Image(systemName: "ladybug")
                                .font(.system(size: 50, weight: .thin))
                                .padding()
                            
                        }
                        .foregroundColor(.red)
                        .alert(isPresented: $bugDeath) {
                            Alert(title: Text("Yeaaahh"),
                                  message: Text("Yout erased the bug!"),
                                  dismissButton: .default(Text("OK")))
                        }
                    } else if self.bugDeath == false && self.timeRemaining <= 0 {
                        Label("God dammit! This bug was to strong...\nYou faild the mission!",
                              systemImage: "cross")
                            .foregroundColor(.blue)
                    } else {
                        Label("Victory! You crushed the bug!\nWith your hammer like thumb!",
                              systemImage: "hammer")
                            .foregroundColor(.green)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
            }
            .foregroundColor(.orange)
            .padding()
            
            .navigationBarTitle("TapTheBug 🐞")
        }
        
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}
