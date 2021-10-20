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
            .padding(.horizontal, 50)
    }
}

struct MathOperatorStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 90, height: 60)
            .font(.largeTitle)
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.orange]), startPoint: .topLeading, endPoint: .bottomLeading))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 50)
    }
}

struct ScoreLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 380, height: 60)
            .font(.largeTitle)
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.green]), startPoint: .topLeading, endPoint: .bottomLeading))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 50)
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
    
    let buttonNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0, 12]
    let mathOperators = ["plus", "minus", "multiply", "divide"]
    @State private var mathOperator = "plus"
    
    let mathOperatorsLogic = [OperatorChoice.plus, OperatorChoice.minus, OperatorChoice.multiply, OperatorChoice.divide]
    @State private var mathOperatorLogicChoice = OperatorChoice.plus
    
    private var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    private var rowItemLayout = Array(repeating: GridItem(.flexible(), spacing: 0), count: 4)
    
    enum OperatorChoice {
        case plus
        case minus
        case multiply
        case divide
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10){
                Spacer()
                
                Label("Current Score: \(score)", systemImage: "ladybug")
                    .modifier(ScoreLabel())
                    
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
                            let mathOperatorIndex = mathOperators.firstIndex(of: mathOperator)!
                            self.mathOperatorLogicChoice = mathOperatorsLogic[mathOperatorIndex]
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
                                let correctAnswer = calculateCorrectResult(first: firstNumber, second: secondNumber, operatorChoice: mathOperatorsLogic[0])
                                
                                print("Correct Answer: ", correctAnswer)
                                print("Submitted Answer: ", result)
                                
                                // Check if Answer is correct
                                compareResults(userResult: result, correctResult: correctAnswer)
                                
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
                                        .modifier(NumPadButtonStyle(keyColor1: Color.green, keyColor2: Color.orange))
                                } else if numb == 12 {
                                    // SUBMIT BUTTON
                                    Label("Submit", systemImage: "ant")
                                        .labelStyle(.titleOnly)
                                        .modifier(NumPadButtonStyle(keyColor1: Color.green, keyColor2: Color.orange))
                                } else {
                                    // NUMPAD
                                    Text("\(numb)")
                                        .modifier(NumPadButtonStyle(keyColor1: Color.orange, keyColor2: Color.red))
                                }
                            }
                            
                        }
                        .buttonStyle(ButtonScaleEffect())
                    }
                }
                
                Spacer()
            }
            .navigationBarTitle("edutainment")
            .toolbar {
                Button("Refres") {
                    self.newEquasion()
                }
            }
        }
        .watermarked(with: "Made by Zwitschki")
        .alert(isPresented: $showAlert) {
            
            Alert(title: Text("Your submitted answer is..."), message: Text("\(alertText)"), dismissButton: .default(Text("Continue")) {
                self.newEquasion()
            })
        }
    }
    
    func calculateCorrectResult(first: Int, second: Int, operatorChoice: OperatorChoice) -> Int {
        switch operatorChoice {
        case .plus:
            let correctResultPlu = first + second
            return correctResultPlu
        case .minus:
            let correctResultMin = first - second
            return correctResultMin
        case .multiply:
            let correctResultMul = first * second
            return correctResultMul
        case .divide:
            let correctResultDiv = first / second
            return correctResultDiv
        }
    }
        
    func compareResults(userResult: String, correctResult: Int) {
        if correctResult == Int(userResult) {
            alertText = "Correct, very good my young mathematician!\nOne Point for Griffendor!"
            self.score += 1
            self.showAlert = true
        } else {
            alertText = "Incorrect, sorry...\nThe correct answer is \(correctResult)\nYou submitted \(userResult)\nNext time think a little harder!"
            self.showAlert = true
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
