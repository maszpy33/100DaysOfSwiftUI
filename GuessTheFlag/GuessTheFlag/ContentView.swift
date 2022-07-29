//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Andreas Zwikirsch on 09.09.21.
//

import SwiftUI

// MODIFIER
struct FlagImage: View {
    var name: String

    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
            
    }
}

// shake effect from objc.io https://talk.objc.io/episodes/S01E173-building-a-shake-animation
struct ShakeEffect: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -30 * sin(position * 2 * .pi), y: 0))
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
    
    var position: CGFloat
    var animationDate: CGFloat {
        get { position }
        set { position = newValue }
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
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner",
        "Canada": "Flag is seperated into three parts, white, red, white. And it has a red maple leaf in the middle"
    ]
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userMessage = ""
    
    @State private var currentScore = 0
    
    @State private var animationAmount = 0.0
    
    // project 6 - challenge 1
    @State private var spinAnimationAmounts = [0.0, 0.0, 0.0]
    @State private var animationIncreaseScore = false
    
    // project 6 - challenge 2
    @State private var animateOpacity = false
    
    // project 6 - challenge 3
    @State private var shakeAnimationAmounts = [0, 0, 0]
    @State private var animationDecreaseScore = false
    
    @State private var allowSubmitAnswer = true
    
    
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
                    FlagImage(name: self.countries[number])
                        .rotation3DEffect(.degrees(self.spinAnimationAmounts[number]), axis: (x: 0, y: 1, z: 0))
                        .modifier(ShakeEffect(shakes: self.shakeAnimationAmounts[number] * 2))
                        .opacity(self.animateOpacity ? (number == self.correctAnswer ? 1 : 0.25) : 1)
                        .onTapGesture {
                            self.flagTapped(number)
                        }
                        .accessibilityLabel(labels[countries[number], default: "Unknowen flag"])
                }
                
                ZStack {
                    Color(red: 0.1, green: 0.1, blue: 0.1).frame(width: 180, height: 40).clipShape(Capsule()).shadow(color: .black, radius: 8)
                    // project 6 - challenge 1 & 3
                    Text("Current Score: \(currentScore)")
                        .foregroundColor(animationIncreaseScore ? .green : (animationDecreaseScore ? .red : .white))
                        .font(.system(size: 20))
                        .bold()
                    
                    Text("+1")
                        .font(.headline)
                        .foregroundColor(animationIncreaseScore ? .green : .clear)
                        .opacity(animationIncreaseScore ? 0 : 1)
                        .offset(x: 0, y: animationIncreaseScore ? -50 : -20)
                    
                    Text("-1")
                        .font(.headline)
                        .foregroundColor(animationDecreaseScore ? .red : .clear)
                        .opacity(animationDecreaseScore ? 0 : 1)
                        .offset(x: 0, y: animationDecreaseScore ? 50 : 20)
                }
//                .offset(x: 0, y: 30)
                
                Button(action: {
                    self.currentScore = 0
                }) {
                    Label("Reset Score", systemImage: "hourglass.tophalf.filled")
                }
                .foregroundColor(.white)
                .frame(width: 180, height: 40)
                .font(.system(size: 20))
                .background(Color.black)
                .clipShape(Capsule())
                .shadow(color: .black, radius: 8)


                
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
        // project 6 - challenge 1
        guard allowSubmitAnswer else { return }
        allowSubmitAnswer = false
        
//            let nextQuestionDelay = 1.5
        let flagAnimationDuration = 0.5
        let scoreUpdateDuration = 1.5
        
        // project 6 - challenge 2
        withAnimation(Animation.easeInOut(duration: flagAnimationDuration)) {
            self.animateOpacity = true
        }
        
        if number == correctAnswer {
            
            scoreTitle = "Correct!"
            if currentScore == countries.count {
                userMessage = "Are you a fucking geography wizard or what!\nYou guessed all flags correct 👍\nFucking legend!\nSet score back to 0"
                currentScore = 0
            } else {
                userMessage = "Score +1"
                currentScore += 1
                
                // project 6 - challenge 1
                withAnimation(Animation.easeInOut(duration: flagAnimationDuration)) {
                    self.spinAnimationAmounts[number] += 360
                }
                withAnimation(Animation.linear(duration: scoreUpdateDuration)) {
                    self.animationIncreaseScore = true
                }
            }
            
        } else {
            scoreTitle = "Wrong!"
            userMessage = "Thats the flag of \(countries[number])"
            currentScore -= 1
            
            // project 6 - challenge 3
            withAnimation(Animation.easeInOut(duration: flagAnimationDuration)) {
                self.shakeAnimationAmounts[number] = 2
            }
            withAnimation(Animation.linear(duration: scoreUpdateDuration)) {
                self.animationDecreaseScore = true
            }
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        // project 6 - challenge 1
        self.spinAnimationAmounts = [0.0, 0.0, 0.0]
        self.animationIncreaseScore = false
        
        // project 6 - challenge 2
        self.animateOpacity = false
        
        // porject 6 - challenge 3
        self.shakeAnimationAmounts = [0, 0, 0]
        self.animationDecreaseScore = false
        
        // project 6 - challenge 1
        // switch back to true when next round starts
        allowSubmitAnswer = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}
