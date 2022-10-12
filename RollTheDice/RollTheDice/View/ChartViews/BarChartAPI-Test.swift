//
//  BarChartAPI-Test.swift
//  RollTheDice
//
//  Created by Andreas Zwikirsch on 13.10.22.
//

import SwiftUI
import Charts


struct BarChartAPI_Test: View {
    @EnvironmentObject var diceVM: DiceViewModel
    @State var diceRound: Dice
    
    @State private var categories: [Int] = []
    
    var body: some View {
        VStack {
            List {
                Chart {
                    ForEach(categories, id: \.self) { numb in
                        BarMark(
                            x: .value("Mount", String(numb)),
                            y: .value("Value", diceRound.numbers.filter { $0 == numb }.count )
                        )
                    }
                }
                .frame(height: 250)
            }
        }
        .onAppear {
            categories = reduceToOccurences()
        }
    }
    
    func reduceToOccurences() -> [Int] {
        return Array(Set(diceRound.numbers)).sorted()
    }
}

struct BarChartAPI_Test_Previews: PreviewProvider {
    static var previews: some View {
        BarChartAPI_Test(diceRound: Dice.sampleDice)
            .preferredColorScheme(.dark)
    }
}
