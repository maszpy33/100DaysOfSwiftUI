//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Andreas Zwikirsch on 10.09.21.
//

import SwiftUI

// MODIFIER
struct TitleOrange: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.orange)
            .padding()
            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(color: .orange, radius: 8)
    }
}

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
        ZStack(alignment: .bottomTrailing) {
            content
            
            Text(text)
                .font(.caption)
                .foregroundColor(.orange)
                .padding(5)
                .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .opacity(0.4)
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
    
    func mainTitle() -> some View {
        self.modifier(TitleOrange())
    }
}


// CONTENT VIEW
struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US", "Canada"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var currentScore = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack (spacing: 30) {
                VStack {
                    Text("Tap the flag of...")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .bold()
                    
                    Text(countries[correctAnswer])
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                    }
                }
                
                Text("Current Score: \(currentScore)")
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                    .bold()
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Youre score is ??"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            currentScore += 1
        } else {
            scoreTitle = "Wrong"
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
