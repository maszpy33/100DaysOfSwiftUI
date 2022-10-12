//
//  BarView.swift
//  RollTheDice
//
//  Created by Andreas Zwikirsch on 13.10.22.
//

import SwiftUI

struct BarView: View {
    var date: Double
    var colors: [Color]
    
    var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        Rectangle()
            .fill(gradient)
            .opacity(date == 0.0 ? 0.0 : 1.0)
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(date: 0, colors: [])
    }
}
