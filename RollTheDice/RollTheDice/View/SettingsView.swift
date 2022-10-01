//
//  SettingsView.swift
//  RollTheDice
//
//  Created by Andreas Zwikirsch on 19.09.22.
//

import SwiftUI
import Combine

struct SettingsView: View {
    
    @EnvironmentObject var diceVM: DiceViewModel
    
    @State private var diceGameRounds: String = "1"
    @State private var diceGameSize: String = "6"
    @State private var diceRollDuration: String = "3"
    
    @State private var wrappedQuickRollModeToggle: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Toggle("Turn Animations \(diceVM.animationToggle ? "Off" : "ON"): ", isOn: $diceVM.animationToggle)
                    .tint(diceVM.primaryAccentColor)
                    .padding(.horizontal, 25)
                    .onChange(of: wrappedQuickRollModeToggle) { newValue in
                        
                    }
                
                Toggle("Turn Quick Roll Mode \(diceVM.quickRollToggle ? "OFF" : "OFF"): ", isOn: $diceVM.quickRollToggle)
                    .tint(diceVM.primaryAccentColor)
                    .padding(.horizontal, 25)
                
                Toggle("Switch Theme to Theme\(diceVM.themeSwitch ? "Two" : "One"): ", isOn: $diceVM.themeSwitch)
                    .tint(diceVM.primaryAccentColor)
                    .padding(.horizontal, 25)
                
                List {
                    Section(header: Text("Dice Game"), footer: Text("to save Dice Game settings pleace press the save button")) {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.title3)
                                .foregroundColor(.accentColor)
                                .padding(8)
                            Text("Last Roll: \(diceVM.lastRollDateTime)uhr")
                        }
                        
                        HStack {
                            Image(systemName: "number.square.fill")
                                .font(.title3)
                                .foregroundColor(.accentColor)
                                .padding(8)
                            TextField("enter dice game rounds", text: $diceGameRounds)
                                .keyboardType(.numberPad)
                                .onReceive(Just(diceGameRounds)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    
                                    if self.diceGameRounds.count > 3 {
                                        self.diceGameRounds.removeLast()
                                    }
                                    
                                    if filtered != newValue {
                                        self.diceGameRounds = filtered
                                    }
                                }
                        }
                        
                        HStack {
                            Image(systemName: "dice.fill")
                                .font(.title3)
                                .foregroundColor(.accentColor)
                                .padding(8)
                            TextField("enter dice size", text: $diceGameSize)
                                .keyboardType(.numberPad)
                                .onReceive(Just(diceGameSize)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        self.diceGameSize = filtered
                                    }
                                    
                                    if (Int(self.diceGameSize) ?? 6) > 50 {
//                                        self.diceGameRounds.removeLast()
                                        self.diceGameSize = "50"
                                    }
                                }
                        }
                        
                        HStack {
                            Image(systemName: "clock")
                                .font(.title3)
                                .foregroundColor(.accentColor)
                                .padding(8)
                            TextField("enter dice size", text: $diceRollDuration)
                                .keyboardType(.numberPad)
                                .onReceive(Just(diceRollDuration)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        self.diceRollDuration = filtered
                                    }
                                    if (Int(self.diceRollDuration) ?? 3) > 10 {
                                        self.diceRollDuration = "7"
                                    }
                                }
                        }
                    }
                    
                    Section(header: Text("Appearence")) {
                        Text("Primary:")
                            .font(.subheadline)
                        Picker("", selection: $diceVM.themeColorPrimary) {
                            ForEach(diceVM.colors, id: \.self) {
                                Text($0.capitalized)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        Text("Secondary:")
                            .font(.subheadline)
                        Picker("", selection: $diceVM.themeColorSecondary) {
                            ForEach(diceVM.colors, id: \.self) {
                                Text($0.capitalized)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
//                .padding(.vertical, 40)
                
//                Button {
//                    saveSettingChanges()
//                } label: {
//                    Text("Save Changes")
//                        .font(.title2)
//                        .bold()
//                        .padding(.horizontal, 30)
//                        .padding(.vertical)
//                        .background(LinearGradient(colors: [diceVM.changeThemeColor(themeColor: diceVM.themeColorPrimary), diceVM.changeThemeColor(themeColor: diceVM.themeColorSecondary)], startPoint: .leading, endPoint: .trailing))
//                        .foregroundColor(.primary)
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                }
//
//                Spacer(minLength: 40)
            }
            .navigationTitle("Settings")
            .toolbar {
                // SAVE SETTING CHANGES
                Button("save") {
                    saveSettingChanges()
                }
            }
        }
        .onAppear {
            diceGameRounds = String(diceVM.rounds)
            diceGameSize = String(diceVM.diceSize)
            diceRollDuration = String(diceVM.duration)
        }
    }

    
    func saveSettingChanges() {
        diceVM.rounds = diceGameRounds
        diceVM.diceSize = diceGameSize
        diceVM.duration = diceRollDuration
//        diceVM.save()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
