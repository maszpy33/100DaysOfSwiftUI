//
//  ContentView.swift
//  Animations
//
//  Created by Andreas Zwikirsch on 30.09.21.
//

import SwiftUI

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(active: CornerRotateModifier(amount: -90, anchor: .topLeading), identity: CornerRotateModifier(amount: 0, anchor: .topLeading))
    }
}

struct ContentView: View {
    @State private var isShowingOrange = false
    
    var body: some View {
        VStack {
            Button("Tap Me") {
                withAnimation {
                    self.isShowingOrange.toggle()
                }
            }
            .foregroundColor(self.isShowingOrange ? .orange : .white)
            if isShowingOrange {
                ZStack {

                    Rectangle()
                        .fill(Color.orange)
                        .frame(width: 200, height: 200)
                        .transition(.pivot)
                    Text("Hello World!")
                        .foregroundColor(.black)
                        .font(.title)
                }
                .transition(.pivot)

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
