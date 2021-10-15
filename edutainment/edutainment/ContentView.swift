//
//  ContentView.swift
//  edutainment
//
//  Created by Andreas Zwikirsch on 09.10.21.
//

import SwiftUI

struct NumPadButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 120, height: 80)
            .font(.largeTitle)
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
            .clipShape(Capsule())
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

struct GradientBackgroundStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .padding(.horizontal, 20)
    }
}

struct ContentView: View {
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var result = 0
    @State private var mathOperator = ["plus", "minus", "multiply", "divide"]
    @State private var mathOperatorSelectioin = 0
    
    @State private var equlIconColor = true
    
    let buttonNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0, 12]
    
    private var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 12){
                Spacer()
                
                HStack {
                    Text("\(firstNumber)")
                        .font(.largeTitle)
                    Label("Icon Only", systemImage: "\(mathOperator[mathOperatorSelectioin])")
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
                
                
                Spacer()
                
                // NUMPAD BUTTONS
                LazyVGrid(columns: gridItemLayout) {
                    ForEach(buttonNumbers, id: \.self) { numb in
                        Button(action: {
                            print("do stuff")
                        }) {
                            HStack{
                                if numb == 10 {
                                    Label("Icon Only", systemImage: "delete.left")
                                        .labelStyle(.iconOnly)
                                        .modifier(NumPadButtonStyle())
                                } else if numb == 12 {
                                    Label("Submit", systemImage: "ant")
                                        .labelStyle(.titleOnly)
                                        .modifier(NumPadButtonStyle())
                                } else {
                                    Text("\(numb)")
                                        .modifier(NumPadButtonStyle())
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
