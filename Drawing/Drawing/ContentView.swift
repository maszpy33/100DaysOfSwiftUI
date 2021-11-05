//
//  ContentView.swift
//  Drawing
//
//  Created by Andreas Zwikirsch on 01.11.21.
//

import SwiftUI


struct Arrow: Shape {
    var arrWidthL: CGFloat
    var arrWidthR: CGFloat
    var arrHeadHight: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: arrWidthL, y: arrHeadHight))
        path.addLine(to: CGPoint(x: rect.minX, y: arrHeadHight))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: arrHeadHight))
        path.addLine(to: CGPoint(x: arrWidthR, y: arrHeadHight))
        path.addLine(to: CGPoint(x: arrWidthR, y: rect.maxY))
        path.addLine(to: CGPoint(x: arrWidthL, y: rect.maxY))
        path.addLine(to: CGPoint(x: arrWidthL, y: arrHeadHight))
        path.addLine(to: CGPoint(x: rect.minX, y: arrHeadHight))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

struct ColorCyclingRectangle: View {
    var amount = 0.0
    var steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                RoundedRectangle(cornerRadius: 20)
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [self.color(for: value, brightness: 1), self.color(for: value, brightness: 0.5)]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}


struct ContentView: View {
    @State private var showArr = false
    @State private var moveArr = 0
    @State private var amount: CGFloat = 10.0
    
    @State private var colorCycle = 0.0
    
    var body: some View {
        ScrollView {
            VStack {
                
                ColorCyclingRectangle(amount: self.colorCycle)
                    .frame(width: 300, height: 300)
                
                Slider(value: $colorCycle)
                    .padding()
                
                Arrow(arrWidthL: 50, arrWidthR: 90, arrHeadHight: 150)
                    .stroke(Color.red, style: StrokeStyle(lineWidth: amount, lineCap: .round, lineJoin: .round))
                    .frame(width: 140, height: 400)
                    .opacity(self.showArr ? 0 : 1)
                    .offset(x: 0, y: self.showArr ? -700 : 0)
                    .animation(.easeInOut(duration: self.showArr ? 0.5 : 1))
                
                Slider(value: $amount, in: 5...30)
                
                Text("Line width: \(Int(round(amount)))")
                
                Button(self.showArr ? "Get Arrow back!" : "Shoot Arrow!") {
                    self.showArr.toggle()
                }
                .padding()
            }
            .padding(120)
            .border(ImagePaint(image: Image("Example"), sourceRect: CGRect(x: 1, y: 0.25, width: 1, height: 1), scale: 0.15), width: 70)
            .ignoresSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
