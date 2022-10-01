//
//  ContentView.swift
//  Layouter
//
//  Created by Andreas Zwikirsch on 13.09.22.
//

import SwiftUI

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}


struct ContentView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<50) { index in
                    GeometryReader { geo in
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(Color(hue: colorHueCalculator(position:  geo.frame(in: .global).minY), saturation: 1, brightness: geo.frame(in: .global).minY/(UIScreen.screenHeight*0.7)))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .rotation3DEffect(.degrees(geo.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                            .opacity(geo.frame(in: .global).minY / 200)
                            .scaleEffect(geo.frame(in: .global).minY / (UIScreen.screenHeight*0.75))
                            .offset(x: UIScreen.screenWidth/10)
                    }
                    .frame(height: 40)
                }
            }
        }
    }
    
    func colorHueCalculator(position: Double) -> Double {
        let hightPercentage = ((position * 100) / UIScreen.screenHeight)/100
        return hightPercentage
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
