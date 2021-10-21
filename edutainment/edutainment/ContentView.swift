//
//  ContentView.swift
//  edutainment
//
//  Created by Andreas Zwikirsch on 09.10.21.
//

import SwiftUI

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

extension View {
    func watermarked(with text: String) -> some View {
        self.modifier(Watermark(text: text))
    }
}

struct NumPadButtonStyle: ViewModifier {
    var keyColor1: Color
    var keyColor2: Color
    
    func body(content: Content) -> some View {
        content
            .frame(width: 120, height: 60)
            .font(.largeTitle)
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [keyColor1, keyColor2]), startPoint: .leading, endPoint: .trailing))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 5)
    }
}

struct MathOperatorStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 90, height: 60)
            .font(.largeTitle)
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .topLeading, endPoint: .bottomLeading))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 5)
    }
}

struct ScoreLabel: ViewModifier {
    var width: CGFloat
    var height: CGFloat
    var buttonColor1: Color
    var buttonColor2: Color
    
    func body(content: Content) -> some View {
        content
            .frame(width: width, height: height)
            .font(.largeTitle)
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [buttonColor1, buttonColor2]), startPoint: .topLeading, endPoint: .bottomLeading))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 5)
    }
}

struct ButtonScaleEffect: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}

struct EquasionStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
    }
}


struct ContentView: View {
    @State private var firstNumber = Int.random(in: 0...12)
    @State private var secondNumber = Int.random(in: 0...12)
    @State private var result = ""
    
    @State private var score = 0
    
    @State private var showAlert = false
    @State private var alertText = ""
    
    @State private var equlIconColor = true
    
    @State private var isCorrectAnswer = false
    
    let buttonNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0, 12]
    let mathOperators = ["plus", "minus", "multiply", "divide"]
    @State private var mathOperator = "plus"
    
    private var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    private var rowItemLayout = Array(repeating: GridItem(.flexible(), spacing: 0), count: 4)
    
    @State private var showSettings = false

    @State private var questionsTotal = 5
    @State private var difficultyLevel = 0
    let difficulties = ["Easy", "Medium", "Hard", "RWTH"]
    
    var body: some View {
        if showSettings {
            SettingsView(questionsTotal: self.$questionsTotal, difficultyLevel: self.$difficultyLevel)
        }
        
        NavigationView {
            VStack(spacing: 10){
                
                Spacer()
                
                Label("Questions \(score)/\(questionsTotal + 1) - Difficulty Level: \(difficulties[difficultyLevel])", systemImage: "rabbit")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .modifier(ScoreLabel(width: 360, height: 25, buttonColor1: .green, buttonColor2: .blue))
                
                
                HStack {
                    Button(action: {
                        score = 0
                        self.newEquasion()
                    }) {
                        Label("Refresh", systemImage: "slider.vertical.3")
                            .labelStyle(.titleOnly)
                            .modifier(ScoreLabel(width: 140, height: 40, buttonColor1: .blue, buttonColor2: .green))
                    }
                    
                    NavigationLink(destination: SettingsView(questionsTotal: self.$questionsTotal, difficultyLevel: self.$difficultyLevel)) {
                        Label("Settings", systemImage: "slider.vertical.3")
                            .modifier(ScoreLabel(width: 200, height: 40, buttonColor1: .blue, buttonColor2: .green))
                    }
                }

                
                Label("Current Score: \(score)", systemImage: "ladybug")
                    .modifier(ScoreLabel(width: 360, height: 60, buttonColor1: .green, buttonColor2: .blue))
                    
                Spacer()
                
                HStack {
                    Text("\(firstNumber)")
                        .font(.largeTitle)
                    Label("Icon Only", systemImage: "\(mathOperator)")
                        .labelStyle(.iconOnly)
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text("\(secondNumber)")
                        .font(.largeTitle)
                    Label("Icon Only", systemImage: "equal")
                        .labelStyle(.iconOnly)
                        .font(.largeTitle)
                        .foregroundColor(self.equlIconColor ? .green : .red)
                    Text("\(result)")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
                .onTapGesture() {
                    print("Number XY")
                }
                
                
                Spacer()
                
                // MATH OPERATOR BUTTONS
                LazyVGrid(columns: rowItemLayout) {
                    ForEach(mathOperators, id: \.self) { mathOperatorChoice in
                        Button(action: {
                            print("Current Math Operator: \(mathOperator)")
                            self.mathOperator = mathOperatorChoice
                        }) {
                            Label("icon only", systemImage: mathOperatorChoice)
                                .labelStyle(.iconOnly)
                                .modifier(MathOperatorStyle())
                        }
                    }
                }
                
                // CONTROLLE BUTTONS
                LazyVGrid(columns: gridItemLayout) {
                    ForEach(buttonNumbers, id: \.self) { numb in
                        Button(action: {
                            if numb == 10 {
                                // DELTE BUTTON LOGIC
                                if result.count > 0 || result.count >= 10 {
                                    self.result.removeLast()
                                } else {
                                    print("do nothing")
                                }
                            } else if numb == 12 {
                                // SUBMIT BUTTON LOGIC
                                let correctAnswer = calculateCorrectResult(first: firstNumber, second: secondNumber, operatorChoice: mathOperator)
                                
                                print("Correct Answer: ", correctAnswer)
                                print("Submitted Answer: ", result)
                                
                                // Check if Answer is correct
                                isCorrectAnswer = compareResults(userResult: result, correctResult: correctAnswer)
                                
                            } else {
                                // NUMPAD BUTTON LOGIC
                                self.result = self.result + String(numb)
                            }
                        }) {
                            HStack{
                                if numb == 10 {
                                    // DELETE BUTTON
                                    Label("Icon Only", systemImage: "delete.left")
                                        .labelStyle(.iconOnly)
                                        .modifier(NumPadButtonStyle(keyColor1: Color.green, keyColor2: Color.blue))
                                } else if numb == 12 {
                                    // SUBMIT BUTTON
                                    Label("Submit", systemImage: "ant")
                                        .labelStyle(.titleOnly)
                                        .modifier(NumPadButtonStyle(keyColor1: Color.blue, keyColor2: Color.green))
                                } else {
                                    // NUMPAD
                                    Text("\(numb)")
                                        .modifier(NumPadButtonStyle(keyColor1: Color.blue, keyColor2: Color.blue))
                                }
                            }
                            
                        }
                        .buttonStyle(ButtonScaleEffect())
                    }
                }
                
                Spacer()
            }
            .navigationBarTitle("edutainment")
            .toolbar{
                Button(action: {
                    print("Hello World!")
                }) {
                    Text("Enter the new world!")
                }
            }
        }
        .watermarked(with: "Made by Zwitschki")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Your submitted answer is..."), message: Text("\(alertText)"), dismissButton: .default(Text("Continue")) {
                if isCorrectAnswer {
                    self.newEquasion()
                    score += 1
                } else {
                    showAlert = false
                }
            })
        }
    }
    
    func calculateCorrectResult(first: Int, second: Int, operatorChoice: String) -> Int {
        if mathOperator == "plus" {
            let correctResult = first + second
            return correctResult
        } else if mathOperator == "minus" {
            let correctResult = first - second
            return correctResult
        } else if mathOperator == "multiply" {
            let correctResult = first * second
            return correctResult
        } else if mathOperator == "divide" {
            let correctResult = first / second
            return correctResult
        } else {
            print("ERROR")
            let correctResult = 404
            return correctResult
        }
    }
        
    func compareResults(userResult: String, correctResult: Int) -> Bool {
        if correctResult == Int(userResult) {
            if score == questionsTotal {
                alertText = "Nice you solved all \(questionsTotal) questions\nOn difficulty level \(difficulties[difficultyLevel])"
                score = 0
                self.showAlert = true
                return true
            } else {
                alertText = "Correct, very good my young mathematician!\nOne Point for Griffendor!"
                self.showAlert = true
                return true
            }

        } else {
            alertText = "Incorrect, sorry...\nYou submitted \(userResult)\nThink a little harder!"
            self.showAlert = true
            return false
        }
    }
    
    func newEquasion() {
        firstNumber = Int.random(in: 0...12)
        secondNumber = Int.random(in: 0...12)
        result = ""
        showAlert = false
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
