//
//  BarChartAPI-Test.swift
//  RollTheDice
//
//  Created by Andreas Zwikirsch on 13.10.22.
//

import SwiftUI
import Charts


struct BarChartView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var diceVM: DiceViewModel
    @State var diceRound: Dice
    @State private var numberX: Int = 0
    @State private var numberY: Int = 0
    
    @State private var categories: [Int] = []
    
    var body: some View {
        NavigationView  {
            VStack(alignment: .leading) {
                Text("Date: \(diceVM.formatDate(date: diceRound.date))")
                Text("Rounds: \(diceRound.rounds)")
                
                Chart {
                    ForEach(categories, id: \.self) { numb in
                        BarMark(
                            x: .value("Mount", String(numb)),
                            y: .value("SOme Stuff", diceRound.numbers.filter { $0 == numb }.count )
                        )
                    }
                }
                .frame(height: 250)
                .foregroundColor(.accentColor)
                
                Text("x: numbers rolled - y: occourence of each value")
                    .font(.subheadline)
                
                Spacer()
            }
            .padding(.horizontal, 15)
            .navigationTitle("Roll Statistic:")
            .toolbar {
                // dismiss sheetView
                Button("dismiss") {
                    dismiss()
                }
            }
            .onAppear {
                categories = reduceToOccurences()
            }
        }
        .accentColor(diceVM.primaryAccentColor)
    }
    
    func reduceToOccurences() -> [Int] {
        return Array(Set(diceRound.numbers)).sorted()
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(diceRound: Dice.sampleDice)
            .preferredColorScheme(.dark)
    }
}
