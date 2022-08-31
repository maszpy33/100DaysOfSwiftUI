//
//  ContentView.swift
//  Flashzilla
//
//  Created by Andreas Zwikirsch on 26.08.22.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase) var scenePhase
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    @State private var currTime = 0
    
    var body: some View {
        VStack {
            Text("\(currTime)")
            Text("Hello World!")
                .onReceive(timer) { time in
                    if counter == 100 {
                        timer.upstream.connect().cancel()
                    } else {
                        print("The time is now \(time)")
                    }
                    
                    counter += 1
                }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("Active")
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
