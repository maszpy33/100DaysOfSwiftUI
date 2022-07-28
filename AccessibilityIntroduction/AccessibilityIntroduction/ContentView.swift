//
//  ContentView.swift
//  AccessibilityIntroduction
//
//  Created by Andreas Zwikirsch on 27.07.22.
//

import SwiftUI

struct ContentView: View {
    
    let pictures = [
        "GOlang1",
        "HolowKnightLogo",
        "Joker_code_logo_darkBG",
        "Le_Brain_logo",
        "linux"
    ]
    
    let labels = [
        "Programming language",
        "Game Character",
        "Programmer Logo",
        "Brain creative and analytic part illustraition",
        "most used operating system logo"
    ]
    
    @State private var selectedPicture = Int.random(in: 0...3)
    
    @State private var value = 10
    
    var body: some View {
        VStack {
            Text("Value: \(value)")
                .padding()
            
            Button("Increment") {
                value += 1
            }
            .padding()
            
            Button("Decrement") {
                value -= 1
            }
            .padding()
        }
        .accessibilityElement()
        .accessibilityLabel("Value")
        .accessibilityValue(String(value))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                value += 1
            case .decrement:
                value -= 1
            default:
                print("Not handled")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
