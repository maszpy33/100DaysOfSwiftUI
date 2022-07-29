//
//  ContentView.swift
//  AccessibilityIntroduction
//
//  Created by Andreas Zwikirsch on 27.07.22.
//

import SwiftUI

struct ContentView: View {
    
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
