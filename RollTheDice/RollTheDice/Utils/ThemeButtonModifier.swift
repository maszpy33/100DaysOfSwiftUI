//
//  ThemeButtonModifier.swift
//  RollTheDice
//
//  Created by Andreas Zwikirsch on 02.10.22.
//

import Foundation
import SwiftUI


struct ButtonThemeOne: ViewModifier {
    var primaryColor: Color
    var secondaryColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .padding()
            .background(Color(red: 0.15, green: 0.15, blue: 0.15))
            .foregroundColor(primaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: secondaryColor, radius: 10, x: 0, y: 0)
    }
}

struct ButtonThemeTwo: ViewModifier {
    var primaryColor: Color
    var secondaryColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .padding()
            .foregroundColor(.primary)
            .background(primaryColor.brightness(-0.3))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(secondaryColor, lineWidth: 1)
                )
            .padding(.horizontal, 15)
    }
}
