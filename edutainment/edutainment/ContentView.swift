//
//  ContentView.swift
//  edutainment
//
//  Created by Andreas Zwikirsch on 09.10.21.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

struct ContentView: View {
    @State private var buttonSwitchB = false
    @State private var animationAmount = 0.0
    @State private var slideButtonEffect = false
    @State private var buttonGuess = 1
    
    @State private var shakeBool: Bool = false
    @State private var attempts: Int = 0
    
    let slideEffectDuration = 1.5
    
    var body: some View {
        ZStack{
            Color.black
            VStack (spacing: 50){
                
                Label("Choose whisely", systemImage: "Brain")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .shadow(color: .white, radius: 12)
                
                HStack(spacing: 30){
                    Button("Left") {
                        self.shakeBool.toggle()
                        self.buttonGuess = Int.random(in: 0...100)
                        let shakeOrNot = isEven(numb: buttonGuess)
                        if shakeOrNot == true {
                            withAnimation(.default) {
                                self.attempts += 1
                            }
                        }
                    }
                    .frame(width: 80, height: 40)
                    .padding()
                    .background(Color(red: 0.2, green: 0.2, blue: 0.8))
                    .font(.title)
                    .clipShape(Capsule())
                    .foregroundColor(.white)
                    .shadow(color: Color.white, radius: 12)
                    .modifier(ShakeEffect(animatableData: CGFloat(self.shakeBool ? 0 : attempts)))
                    
                    Button("Right") {
                        self.shakeBool.toggle()
                        self.buttonGuess = Int.random(in: 0...100)
                        let shakeOrNot = isEven(numb: buttonGuess)
                        if shakeOrNot == true {
                            withAnimation(.default) {
                                self.attempts += 1
                            }
                        }
                    }
                    .frame(width: 80, height: 40)
                    .padding()
                    .background(Color(red: 0.8, green: 0.2, blue: 0.2))
                    .font(.title)
                    .clipShape(Capsule())
                    .foregroundColor(.white)
                    .shadow(color: Color.white, radius: 12)
                    .modifier(ShakeEffect(animatableData: CGFloat(self.shakeBool ? attempts : 0)))
                }
                
                Text("Output: \(buttonGuess)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .shadow(color: .white, radius: 12)
                
                
                Button("Tap Me") {
                    self.buttonSwitchB.toggle()
                    withAnimation(Animation.linear(duration: slideEffectDuration)) {
                        self.slideButtonEffect.toggle()
                    }
                }
                .frame(width: 100, height: 50)
                .padding()
                .background(self.slideButtonEffect ? .clear : Color(red: 0.2, green: 0.2, blue: 0.2))
                .foregroundColor(self.slideButtonEffect ? .clear : .green)
                .font(.title)
                .clipShape(Capsule())
                .opacity(self.buttonSwitchB ? 0 : 1)
                .shadow(color: Color.green, radius: self.slideButtonEffect ? 0 : 12)
                .animation(.default)
                .offset(x: 0, y: self.slideButtonEffect ? -250 : 0)

                
                Label(self.buttonSwitchB ? "Brain Off" : "Brain On", systemImage: "leaf")
                    .frame(width: 250, height: 80)
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .shadow(color: self.buttonSwitchB ? Color.red : Color.green, radius: 8, x: 8, y: 8)
                    .blur(radius: self.buttonSwitchB ? 0.99 : 0)
                    .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 1))
                    .animation(self.buttonSwitchB ?  .default : .interpolatingSpring(stiffness: 12, damping: 2))
                
                Button("Tap Me") {
                    self.buttonSwitchB.toggle()
                    withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                        self.animationAmount += 360
                    }
                    withAnimation(Animation.linear(duration: slideEffectDuration)) {
                        self.slideButtonEffect.toggle()
                    }
                }
                .frame(width: 100, height: 50)
                .padding()
                .background(self.slideButtonEffect ? Color(red: 0.2, green: 0.2, blue: 0.2) : .clear)
                .foregroundColor(self.slideButtonEffect ? .red : .clear)
                .font(.title)
                .clipShape(Capsule())
                .opacity(self.buttonSwitchB ? 1 : 0)
                .shadow(color: Color.red, radius: self.slideButtonEffect ? 12 : 0)
                .animation(.default)
                .offset(x: 0, y: self.slideButtonEffect ? 0 : 250)
            }
        }
        .ignoresSafeArea(.all)

        
    }
    
    func isEven(numb: Int) -> Bool {
        if (numb % 2) == 0 {
            return true
        }
        return false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
