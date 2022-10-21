//
//  DiceRollView.swift
//  RollTheDice
//
//  Created by Andreas Zwikirsch on 19.09.22.
//

import SwiftUI

struct DiceRollView: View {
    
    @EnvironmentObject var diceVM: DiceViewModel
    @EnvironmentObject var hapticM: HapticManager
    
    @State private var diceNumber: Int = 1
    
    @State var colorTheme: Color = .accentColor
    
    let secondaryAccentColor = Color("SecondaryAccentColor")
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var diceRollCountdownTime: Int = 3
    
    // dice variables
    let diceAnimationCounter = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var disableDiceButton: Bool = false
//    @State private var diceSize: Int = 6
    @State private var currentRound = 0
    
    @State private var roundsSettings: Int = 3
    @State private var diceSizeSettings: Int = 6
    @State private var rollDurationSettings: Int = 2
    
    // animate dice result
    @State private var resultAnimation: Bool = false
    @State private var resultAngle: Double = 0.0
    
    // quickAddAnimation
    @State private var animateQuickAdd: Bool = false
    @State private var xNumberOffset: CGFloat = 0.0
    
    var body: some View {
        NavigationView {
            VStack {
                HeadDiceAnimationView()
                    .environmentObject(diceVM)
                    .padding(35)
                
//                Spacer()
                
                VStack(alignment: .leading) {
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
                        Text("Dice Round: \(currentRound)/\(diceVM.rounds)")
                    }
                    
                    HStack {
                        Image(systemName: "dice.fill")
                            .font(.title3)
                            .foregroundColor(.accentColor)
                            .padding(8)
                        Text("Current dice size: \(diceVM.diceSize)")
                    }

                }
                                
                Text("\(diceNumber)")
                    .font(.system(size: 60))
                    .padding([.top, .bottom], 50)
                    .scaleEffect(resultAnimation ? 1.8 : 1.0)
                    .rotationEffect(.degrees(resultAngle))
                    .offset(x: xNumberOffset)
                
                // LOGIC DICE ROLL BUTTON
                Button {
                    diceVM.lastRollDateTime = diceVM.formatDate(date: Date())
                    
                    // QUICK ROLL IS ON
                    guard !diceVM.quickRollToggle else {
                        diceVM.quickRollMode()
                        currentRound = 0
                        
                        withAnimation(.easeIn(duration: Double(rollDurationSettings)*0.5)) {
//                            animateQuickAdd = true
                            xNumberOffset = 250
                        }
                        
                        hapticM.quickRollHapticOne()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(rollDurationSettings)) {
                            hapticM.complexSuccess()
                            
                            xNumberOffset = -250
                            diceNumber = Int.random(in: 1..<diceSizeSettings)
                            
                            withAnimation(.easeOut) {
//                                self.animateQuickAdd = false
                                xNumberOffset = 0
                            }
                            
                            diceVM.numbCache.append(diceNumber)
                            print("Number: \(diceVM.numbCache)")
                            
                            if diceVM.quickRollToggle {
                                currentRound = Int(diceVM.rounds)!
                            } else {
                                currentRound += 1
                            }
                            
                            self.disableDiceButton = false
                        }
                        
                        return
                    }
                    
                    // QUICK ROLL IS OFF
                    if resultAnimation {
                        withAnimation(.linear) {
                            resultAnimation = false
                        }
                    }
                    
                    hapticM.numberRotationHaptic(duration: Double(diceVM.duration) ?? 1.0)
                    
                    if currentRound == roundsSettings {
                        currentRound = 0
                        
                        // save data to data history
                        let newDiceRoll = Dice(numbers: diceVM.numbCache, diceSize: diceSizeSettings, rounds: roundsSettings, date: Date())
                        diceVM.diceRollList.append(newDiceRoll)
                        diceVM.save()
                        diceVM.numbCache = []
                    }
                    
                    disableDiceButton = true
                    // set dice countdown back to 3
                    diceRollCountdownTime = Int(diceVM.duration) ?? 3
                    
                    // rotate result number
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(rollDurationSettings)) {
                        // vibrate device
                        hapticM.complexSuccess()
                        
                        withAnimation(.easeOut) {
                            self.resultAnimation = true
                            self.resultAngle += 360
                        }
                        
                        diceVM.numbCache.append(diceNumber)
                        print("Number: \(diceVM.numbCache)")
                        
                        currentRound += 1
                        
                        self.disableDiceButton = false
                    }
                    
//                    DispatchQueue.main.async {
//                        hapticM.numberRotationHaptic(duration: Double(diceVM.duration) ?? 1.0)
//                    }
                    
                    // animate dice result
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(rollDurationSettings + 2)) {
                        withAnimation(.easeOut) {
                            self.resultAnimation = false
                        }
                    }
                    
                } label: {
                    // SWITCH BUTTON THEME
                    if diceVM.themeSwitch {
                        Text(diceVM.quickRollToggle ? "Quick Roll" : "Roll Dice")
                            .modifier(ButtonThemeOne(primaryColor: diceVM.primaryAccentColor, secondaryColor: diceVM.secondaryAccentColor))
                    } else {
                        Text(diceVM.quickRollToggle ? "Quick Roll" : "Roll Dice")
                            .modifier(ButtonThemeTwo(primaryColor: diceVM.primaryAccentColor, secondaryColor: diceVM.secondaryAccentColor))
                    }
                }
                .disabled(disableDiceButton)
                .padding(40)
                
//                Spacer()
            }
            .onReceive(diceAnimationCounter) { diceCount in
                guard disableDiceButton else { return }
                
                diceNumber = Int.random(in: 1..<diceSizeSettings)
            }
            .onReceive(timer) { time in
                guard disableDiceButton else { return }
                
                if diceRollCountdownTime > 0 {
                    diceRollCountdownTime -= 1
                } else {

                }
            }
        }
        .onAppear {
            diceRollCountdownTime = Int(diceVM.duration) ?? 3
            rollDurationSettings = Int(diceVM.duration) ?? 3
            diceSizeSettings = (Int(diceVM.diceSize) ?? 6)+1
            roundsSettings = Int(diceVM.rounds) ?? 3
            
            if currentRound >= roundsSettings {
                currentRound = 0
            }
        }
    }
}

struct DiceRollView_Previews: PreviewProvider {
    static var previews: some View {
        DiceRollView()
    }
}
