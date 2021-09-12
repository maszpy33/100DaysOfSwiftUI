//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Andreas Zwikirsch on 09.09.21.
//

import SwiftUI

// MODIFIER
struct TextFormat: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .foregroundColor(.red)
            
    }
}


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

// EXTENSION VIEW
extension View {
    
    func watermarked(with text: String) -> some View {
        self.modifier(Watermark(text: text))
    }
    
    func formatText() -> some View {
        self.modifier(TextFormat())
    }
}

extension Image {
    func FlagImage() -> some View {
        self
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US", "Canada"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userMessage = ""
    
    @State private var currentScore = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.black, .white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                
            
            VStack (spacing: 30) {
                Spacer()
                VStack {
                    Text("Tap the flag of...")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .bold()
                    
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .FlagImage()
//                        Image(self.countries[number])
//                            .renderingMode(.original)
//                            .clipShape(Capsule())
//                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
//                            .shadow(color: .black, radius: 2)
                    }
                }
                ZStack {
                    Color(red: 0.1, green: 0.1, blue: 0.1).frame(width: 180, height: 40).clipShape(Capsule())
                    Text("Current Score: \(currentScore)")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .bold()
                }

                
                Spacer()
            }
            .watermarked(with: "Made by Zwitschki")
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(userMessage), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            
            if currentScore == countries.count {
                userMessage = "Are you a fucking geography wizard or what!\nYou guessed all flags correct 👍\nFucking legend!\nSet score back to 0"
                currentScore = 0
            } else {
                userMessage = "Score +1"
                currentScore += 1
            }
            
        } else {
            scoreTitle = "Wrong!"
            userMessage = "Thats the flag of \(countries[number])"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}
