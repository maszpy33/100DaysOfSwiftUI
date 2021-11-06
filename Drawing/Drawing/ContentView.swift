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
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [self.color(for: value, brightness: 1), self.color(for: value, brightness: 0.5)]), startPoint: .top, endPoint: .bottom), lineWidth: 10)
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

// Spirograph of Day 45
struct Spirograph: Shape {
    let innerRaidus: Int
    let outerRadius: Int
    let distance: Int
    let amount: CGFloat
    
    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        
        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }
        
        return a
    }
    
    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRaidus, outerRadius)
        let outerRadius = CGFloat(self.outerRadius)
        let innerRadius = CGFloat(self.innerRaidus)
        let distance = CGFloat(self.distance)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(2 * CGFloat.pi * outerRadius / CGFloat(divisor)) * amount
        
        var path = Path()
        
        for theta in stride(from: 0, through: endPoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)
            
            x += rect.width / 2
            y += rect.height / 2
            
            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}


struct ContentView: View {
    @State private var showArr = false
    @State private var moveArr = 0
    @State private var slideVal: CGFloat = 10.0
    
    @State private var colorCycle = 0.0
    
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount: CGFloat = 1.0
    @State private var hue = 0.6
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                
                // Spirograph of Day 45
                Spirograph(innerRaidus: Int(innerRadius), outerRadius: Int(outerRadius), distance: Int(distance), amount: amount)
                    .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
                    .frame(width: 300, height: 300)
                
                Group {
                    Text("Inner radius: \(Int(innerRadius))")
                    Slider(value: $innerRadius, in: 10...150, step: 1)
                        .padding([.horizontal, .bottom])
                    
                    Text("Outer radius: \(Int(innerRadius))")
                    Slider(value: $outerRadius, in: 10...150, step: 1)
                        .padding([.horizontal, .bottom])
                    
                    Text("Distance: \(Int(distance))")
                    Slider(value: $distance, in: 10...150, step: 1)
                        .padding([.horizontal, .bottom])
                    
                    Text("Amount: \(Int(amount), specifier: "%.2f")")
                    Slider(value: $amount)
                        .padding([.horizontal, .bottom])
                    
                    Text("Color: \(Int(hue))")
                    Slider(value: $hue)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                ColorCyclingRectangle(amount: self.colorCycle)
                    .frame(width: 300, height: 300)
                
                Slider(value: $colorCycle)
                    .padding()
                
                Arrow(arrWidthL: 50, arrWidthR: 90, arrHeadHight: 150)
                    .stroke(Color.red, style: StrokeStyle(lineWidth: slideVal, lineCap: .round, lineJoin: .round))
                    .frame(width: 140, height: 400)
                    .opacity(self.showArr ? 0 : 1)
                    .offset(x: 0, y: self.showArr ? -700 : 0)
                    .animation(.easeInOut(duration: self.showArr ? 0.5 : 1))
                
                Slider(value: $slideVal, in: 5...30)
                Text("Line width: \(Int(round(slideVal)))")
                
                Button(action: {
                    self.showArr.toggle()
                }) {
                    Label(self.showArr ? "Get Arrow back!" : "Shoot Arrow!", systemImage: "arrow.up")
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
