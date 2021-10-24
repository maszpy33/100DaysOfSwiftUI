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
                .opacity(0.2)
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
            .frame(width: 100, height: 60)
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
            .frame(width: 70, height: 60)
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
    let difficultyLogo = ["tortoise", "ladybug", "hare", "brain.head.profile"]
    let difficultyLogo2 = ["owl", "elephant", "duck", "goat"]
    
    @State private var slideButtonEffect = false
    
    @State private var speakingBubbleText = "Hello my young mathematician! And well this is a quiet long test text, to look how much character fit in the speaking bubble 3"
    
    var body: some View {
        if showSettings {
            SettingsView(questionsTotal: self.$questionsTotal, difficultyLevel: self.$difficultyLevel)
        }
        
        NavigationView {
            ZStack {
                VStack(spacing: 10){
                    
                    Spacer()
                    
                    HStack(spacing: 0){
                        Button(action: {
                            score = 0
                            self.newEquasion()
                            self.minusAndiDivideOperatorCheck()
                        }) {
                            Label("Refresh", systemImage: "repeat")
                                .modifier(ScoreLabel(width: 175, height: 40, buttonColor1: .blue, buttonColor2: .green))
                        }
                        .buttonStyle(ButtonScaleEffect())
                        
                        NavigationLink(destination: SettingsView(questionsTotal: self.$questionsTotal, difficultyLevel: self.$difficultyLevel)) {
                            Label("⚙️ Settings", systemImage: "slider.horizontal.3")
                                .labelStyle(.titleOnly)
                                .modifier(ScoreLabel(width: 175, height: 40, buttonColor1: .blue, buttonColor2: .green))
                        }
                        .buttonStyle(ButtonScaleEffect())
                    }
                    
                    Spacer()
                    
                    HStack{
                        Image("\(difficultyLogo2[difficultyLevel])")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70, alignment: .leading)
                        Text("Your Score: \(score)")
                            .bold()
                            .font(.title)
                            .frame(width: 260, height: 70)
                            .overlay(RoundedRectangle(cornerRadius: 18)
                                        .stroke(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .topLeading, endPoint: .bottomLeading), lineWidth: 4))
                    }
                    
                    // EQUATION
                    ZStack {
                        Color.red.frame(width: 360, height: 95)
                            .opacity(0)
                            .overlay(RoundedRectangle(cornerRadius: 18)
                                        .stroke(LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .topLeading, endPoint: .bottomLeading), lineWidth: 4))
                        
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
                                .foregroundColor(self.equlIconColor ? .orange : .red)
                            Text("\(result)")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    
                    
                    Spacer()
                    
                    // MATH OPERATOR BUTTONS
                    LazyVGrid(columns: rowItemLayout) {
                        ForEach(mathOperators, id: \.self) { mathOperatorChoice in
                            Button(action: {
                                print("Current Math Operator: \(mathOperator)")
                                self.mathOperator = mathOperatorChoice
                                self.minusAndiDivideOperatorCheck()
                            }) {
                                Label("icon only", systemImage: mathOperatorChoice)
                                    .labelStyle(.iconOnly)
                                    .modifier(MathOperatorStyle())
                            }
                            .buttonStyle(ButtonScaleEffect())
                        }
                    }
                    
                    // NUMPAD BUTTONS
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
                                            .modifier(NumPadButtonStyle(keyColor1: Color.red, keyColor2: Color.red))
                                    } else if numb == 12 {
                                        // SUBMIT BUTTON
                                        Label("Submit", systemImage: "ant")
                                            .labelStyle(.titleOnly)
                                            .font(.title)
                                            .modifier(NumPadButtonStyle(keyColor1: Color.green, keyColor2: Color.green))
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
                        Text("Level: \(difficulties[difficultyLevel]) | Question \(score)/\(questionsTotal + 1)")
                    }
                }
                
                if showAlert {
                    ZStack {
                        VStack{
                            ZStack{
                                Image("speakingBubble3")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 250, alignment: .top)
                                    .offset(y: 20)
                                Text("\(alertText)")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20, weight: .semibold))
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: 180, maxHeight: 120, alignment: .top)
                            }
                            .offset(x: -30, y: 50)
                            
                            ZStack {
                                Color.black.frame(width: 360, height: 240)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                
                                HStack{
                                    Text("To coninue\ntap Fin!")
                                        .font(.title)
                                        .bold()
                                        .modifier(ScoreLabel(width: 180, height: 90, buttonColor1: .blue, buttonColor2: .black))
                                    
                                    Button(action: {
                                        showAlert = false
                                        self.newEquasion()
                                        self.minusAndiDivideOperatorCheck()
                                    }) {
                                        Image("whale_fin")
                                            .resizable()
                                            .scaledToFit()
                                            .shadow(color: .white, radius: 8)
                                            .frame(width: 90, height: 90, alignment: .top)
                                    }
                                    .buttonStyle(ButtonScaleEffect())
                                }
                            }
                        }
                    }
                    
                }
                
            }
        }
        .watermarked(with: "Made by Zwitschki")
        //        .alert(isPresented: $showAlert) {
        //            Alert(title: Text("Your submitted answer is..."), message: Text("\(alertText)"), dismissButton: .default(Text("Continue")) {
        //                if isCorrectAnswer {
        //                    self.newEquasion()
        ////                    score += 1
        //                } else {
        //                    showAlert = false
        //                }
        //            })
        //        }
    }
    
    func minusAndiDivideOperatorCheck() {
        // Avoid negativ results && division with comma result
        if self.mathOperator == "minus" && firstNumber < secondNumber{
            (firstNumber, secondNumber) = (secondNumber, firstNumber)
        } else if self.mathOperator == "divide" {
            while firstNumber % secondNumber != 0 {
                self.newEquasion()
            }
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
                alertText = "Correct!\nNice you solved all \(questionsTotal + 1) questions\nOn difficulty level \(difficulties[difficultyLevel])"
                score = 0
                self.showAlert = true
                return true
            } else {
                alertText = "Correct, very good my young mathematician!\nOne Point for Griffendor!"
                self.showAlert = true
                score += 1
                return true
            }
            
        } else {
            alertText = "Incorrect, sorry...\nYou submitted \(userResult)\nThink a little harder!"
            self.showAlert = true
            return false
        }
    }
    
    func newEquasion() {
        var range1 = 33
        var range2 = 404
        
        if difficultyLevel == 0 {
            range1 = 0
            range2 = 10
        } else if difficultyLevel == 1 {
            range1 = 0
            range2 = 12
        } else if difficultyLevel == 2 {
            range1 = 0
            range2 = 20
        } else if difficultyLevel == 3 {
            range1 = 33
            range2 = 404
        }
        
        firstNumber = Int.random(in: range1...range2)
        secondNumber = Int.random(in: range1...range2)
        
        result = ""
        showAlert = false
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
