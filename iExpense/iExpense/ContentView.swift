//
//  ContentView.swift
//  iExpense
//
//  Created by Andreas Zwikirsch on 27.10.21.
//

import SwiftUI

struct SecondView: View {
    @Environment(\.presentationMode) var presentationMode
    var name: String
    
    var body: some View {
        Label("Second View", systemImage: "globe.asia.australia")
        Text("User: \(name)")
        Button("Dismiss") {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}
struct ContentView: View {
    @State private var showingSheet = false
    
    var body: some View {
        Label("First View", systemImage: "drop")
        Button("Show Sheet") {
            self.showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            SecondView(name: "@maszpy")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
