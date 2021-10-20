//
//  ContentView.swift
//  edutainment
//
//  Created by Andreas Zwikirsch on 09.10.21.
//

import SwiftUI

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
    let firstNumber = 3
    let secondNumber = 8
    @State private var result = ""
    @State private var mathOperator = "plus"
    
//    @State private var focusedNumber = 1
    
    @State private var equlIconColor = true
    
    let buttonNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0, 12]
    let mathOperators = ["plus", "minus", "multiply", "divide"]
    
    private var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    private var rowItemLayout = Array(repeating: GridItem(.flexible(), spacing: 0), count: 4)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10){
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
                            print("Math Operator: \(mathOperator)")
                            self.mathOperator = mathOperatorChoice
                        }) {
                            Label("icon only", systemImage: mathOperatorChoice)
                                .labelStyle(.iconOnly)
                                .modifier(MathOperatorStyle())
                        }
                    }
                }
                
                // NUMPAD BUTTONS
                LazyVGrid(columns: gridItemLayout) {
                    ForEach(buttonNumbers, id: \.self) { numb in
                        Button(action: {
                            if numb == 10 {
                                if result.count > 0 || result.count >= 10 {
                                    self.result.removeLast()
                                } else {
                                    print("do nothing")
                                }
                            } else if numb == 12 {
                                print("Submit")
                            } else {
                                self.result = self.result + String(numb)
                            }
                        }) {
                            HStack{
                                if numb == 10 {
                                    Label("Icon Only", systemImage: "delete.left")
                                        .labelStyle(.iconOnly)
                                        .modifier(NumPadButtonStyle(keyColor1: Color.green, keyColor2: Color.orange))
                                } else if numb == 12 {
                                    Label("Submit", systemImage: "ant")
                                        .labelStyle(.titleOnly)
                                        .modifier(NumPadButtonStyle(keyColor1: Color.green, keyColor2: Color.orange))
                                } else {
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
        }
        
    }
    
    func operatorFoo() {
        print("Stuff")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
