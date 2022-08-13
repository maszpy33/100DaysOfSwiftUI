//
//  ContentView.swift
//  HotProspects
//
//  Created by Andreas Zwikirsch on 13.08.22.
//

import SwiftUI

@MainActor class User: ObservableObject {
    @Published var name = "Taylor Swift"
}

struct DisplayView: View {
    static let tag = "DisplayView"
    @EnvironmentObject var user: User
    
    var body: some View {
        Text("Display View: \(user.name)")
    }
}

struct EditView: View {
    static let tag = "EditView"
    @EnvironmentObject var user: User
    
    var body: some View {
        Text("Edit View: \(user.name)")
    }
}

struct ContentView: View {
    static let tag = "ContentView"
    @StateObject var user = User()
    
    @State private var selectedTab = "One"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DisplayView()
                .environmentObject(user)
                .tabItem {
                    Label("MainView", systemImage: "star")
                }
                .tag(DisplayView.tag)
            
            EditView()
                .environmentObject(user)
                .tabItem {
                    Label("EditView", systemImage: "circle")
                }
                .tag("Two")
                .tag(EditView.tag)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
