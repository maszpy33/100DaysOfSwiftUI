//
//  ContentView.swift
//  RollTheDice
//
//  Created by Andreas Zwikirsch on 19.09.22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var diceVM = DiceViewModel()
    
    var body: some View {
        TabView {
            DiceRollView()
                .environmentObject(diceVM)
                .tabItem {
                    Label("Roll Dice", systemImage: "dice")
                }
            
            HistoryView()
                .environmentObject(diceVM)
                .tabItem {
                    Label("History", systemImage: "list.bullet.rectangle.portrait")
                }
            
            SettingsView()
                .environmentObject(diceVM)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(diceVM.primaryAccentColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
