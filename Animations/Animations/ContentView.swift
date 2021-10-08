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
    @State private var testToggle = false
    
    var body: some View {
        VStack(spacing: 30) {
            Button("Tap Me") {
                withAnimation {
                    self.isShowingOrange.toggle()
                }
            }
            .foregroundColor(self.isShowingOrange ? .orange : .white)
            .font(self.isShowingOrange ? .title3 : .title)
            .padding()
            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
            .clipShape(self.isShowingOrange ? RoundedRectangle(cornerRadius: 0) : RoundedRectangle(cornerRadius: 25))
            .shadow(color: .white, radius: 8)
            .animation(.default)
            // wie kann ich den ButtonTransitionForm modifier mit dem toggel verwenden
            
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
    
    func ifTrue(_ condition:Bool, apply:(AnyView) -> (AnyView)) -> AnyView {
        if condition {
            return apply(AnyView(self))
        }
        else {
            return AnyView(self)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
