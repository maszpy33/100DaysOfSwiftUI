//
//  HeadDiceAnimationView.swift
//  RollTheDice
//
//  Created by Andreas Zwikirsch on 01.10.22.
//

import SwiftUI


extension Animation {
    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}

struct HeadDiceAnimationView: View {
    
    @EnvironmentObject var diceVM: DiceViewModel
    
    @State private var animate: Bool = false
    
    var body: some View {
        VStack {
            if diceVM.animationToggle {
                VStack {
                    Image(systemName: "dice.fill")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 60))
                    
                    Text("The Dice Roll Game")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 30))
                }
                .onAppear(perform: addAnimation)
                .shadow(
                    color: diceVM.animationToggle ? diceVM.changeThemeColor(themeColor: diceVM.themeColorSecondary).opacity(0.7) : Color.accentColor.opacity(0.7),
                    radius: animate ? 30 : 10,
                    x: 0,
                    y: animate ? 15 : 7)
                .scaleEffect(animate ? 1.2 : 1.0)
                
            } else {
                if diceVM.themeSwitch {
                    VStack {
                        Image(systemName: "dice.fill")
                            .foregroundColor(.accentColor)
                            .font(.system(size: 60))
                        
                        Text("The Dice Roll Game")
                            .foregroundColor(.accentColor)
                            .font(.system(size: 30))
                    }
                    .shadow(
                        color: diceVM.primaryAccentColor.opacity(0.7),
                        radius: 10,
                        x: 0,
                        y: 7)
                } else {
                    ZStack {
                        VStack {
                            Image(systemName: "dice.fill")
                                .foregroundColor(diceVM.secondaryAccentColor)
                                .font(.system(size: 60))
                            
                            Text("The Dice Roll Game")
                                .foregroundColor(diceVM.secondaryAccentColor)
                                .font(.system(size: 30))
                                .fontWeight(.heavy)
                        }
                        .offset(x: 2, y: 2)
                        
                        VStack {
                            Image(systemName: "dice.fill")
                                .foregroundColor(.accentColor)
                                .font(.system(size: 60))
                            
                            Text("The Dice Roll Game")
                                .foregroundColor(.accentColor)
                                .font(.system(size: 30))
                                .fontWeight(.heavy)
                        }

                    }
                }
            }
        }
        .onAppear(perform: addAnimation)
        .onTapGesture {
            // FIXME: animation toggle on tap dose not work properly
            diceVM.animationToggle.toggle()
            if diceVM.animationToggle {
                addAnimation()
            }
        }
    }
    
    func addAnimation() {
        guard diceVM.animationToggle else { return }
//        guard !animate else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(
                Animation
                    .easeInOut(duration: diceVM.animationToggle ? 2.5 : 0.0)
                    .repeatForever()
            ) {
                animate.toggle()
            }
        }
    }
}

struct HeadDiceAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        HeadDiceAnimationView()
    }
}
