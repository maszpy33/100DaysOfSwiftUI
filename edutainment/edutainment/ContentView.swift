//
//  ContentView.swift
//  edutainment
//
//  Created by Andreas Zwikirsch on 09.10.21.
//

import SwiftUI

struct NumPadButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 110, height: 60)
            .background(Color(red: 0.1, green: 0.4, blue: 0.8))
            .foregroundColor(.white)
            .font(.title)
            .clipShape(Capsule())
    }
}

struct EquasionStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
    }
}

struct ContentView: View {
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var result = 0
    @State private var mathOperator = ["plus", "minus", "multiply", "divide"]
    @State private var mathOperatorSelectioin = 0
    
    private var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 5), count: 3)
    
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
                    Text("\(secondNumber)")
                        .font(.largeTitle)
                    Label("Icon Only", systemImage: "equal")
                        .labelStyle(.iconOnly)
                        .font(.largeTitle)
                    Text("\(result)")
                        .font(.largeTitle)
                }
                
                
                Spacer()
                
                LazyVGrid(columns: gridItemLayout, spacing: 30) {
                    ForEach((1...9), id: \.self) {
                        Button("\($0)") {
                            
                        }
                        .modifier(NumPadButton())
                    }
                }

//                ForEach(0..<3) { row in
//                    HStack(spacing: 30){
//                        ForEach(0..<3) { column in
//                            ForEach((0..<9), id: \.self) {
//                                Button("\($0)") {
//
//                                }
//                                .modifier(NumPadButton())
//                            }
//
//                        }
//                    }
//                }
                
                HStack(spacing: 20) {
                    Button(action: {
                        print("Some action")
                    }) {
                        Label("Icon Only", systemImage: "delete.left")
                            .labelStyle(.iconOnly)
                            .frame(width: 110, height: 60)
                            .background(Color(red: 0.8, green: 0.4, blue: 0.2))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Capsule())
                    }
                    
                    Button(action: {
                        print("Some action")
                    }) {
                        Label("0", systemImage: "ant")
                            .modifier(NumPadButton())
                            .labelStyle(.titleOnly)
                    }
                    
                    Button(action: {
                        print("Some action")
                    }) {
                        Label("Submit", systemImage: "delete.left")
                            .labelStyle(.titleOnly)
                            .frame(width: 110, height: 60)
                            .background(Color(red: 0.2, green: 0.8, blue: 0.2))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Capsule())
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
