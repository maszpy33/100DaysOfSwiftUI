//
//  HistoryView.swift
//  RollTheDice
//
//  Created by Andreas Zwikirsch on 19.09.22.
//

import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject var diceVM: DiceViewModel
    @State private var showingAlert: Bool = false
    @State private var animateStatisticTransition: Bool = false
    @State private var showStatisticsView: Bool = false
    
    @State var selectedDiceRound: Dice?
    
    var body: some View {
        NavigationView {
            List {
                ScrollView {
                    ForEach(diceVM.diceRollList.enumerated().reversed(), id: \.offset) { index, diceRound in
                        VStack(alignment: .leading) {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("\(index + 1).")
                                        Image(systemName: "dice.fill")
                                            .foregroundColor(.accentColor)
                                        Text("Date: \(diceVM.formatDate(date: diceRound.date))")
                                    }
                                    
                                    Text("Rounds: \(diceRound.rounds)")
                                }
                                
                                Spacer()
  
                                Button {

                                    selectedDiceRound = diceRound
                                    showStatisticsView = true
                                    
                                } label: {
                                    Text("📊")
                                        .font(.system(size: 25))
                                        .padding(5)
                                        .scaleEffect(animateStatisticTransition ? 50 : 1)
                                        .brightness(animateStatisticTransition ? -1 : 0)
                                }
                                .sheet(isPresented: $showStatisticsView, onDismiss: dismissAnimation) {
                                    BarChartView(diceRound: selectedDiceRound ?? Dice.sampleDice).environmentObject(diceVM)
                                }
                            }
                            
                            ScrollView(.horizontal) {
                                HStack(spacing: 10) {
                                    ForEach(diceRound.numbers.indices, id: \.self) { index in
                                        VStack {
                                            ZStack {
                                                Image(systemName: "square.fill")
                                                    .resizable()
                                                    .foregroundColor(diceVM.primaryAccentColor)
                                                    .font(.system(size: 36))
                                                    .brightness(-0.3)
                                                Text("\(diceRound.numbers[index])")
                                                    .font(.system(size: 28))
                                            }
                                            Text("\(index + 1)")
                                                .font(.system(size: 8))
                                        }
                                    }
                                }
                                .padding(.bottom, 5)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .onDelete(perform: delete)
                }
                .padding(.horizontal, 10)
            }
            .listStyle(.plain)
            .navigationTitle("Dice Roll History:")
            .toolbar {
                // reset hist data
                Button("reset data") {
                    showingAlert = true
                }
                .alert("really delet the Dice Roll History?", isPresented: $showingAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        diceVM.diceRollList = []
                        diceVM.save()
                    }
                }
            }
        }
        .onAppear {
            print("DiceRoll List length: \(diceVM.diceRollList.count)")
        }
    }
    
    // helper function for sheet dismiss
    func dismissAnimation() {
        withAnimation(.linear) {
            animateStatisticTransition = false
        }
    }
    
    func outputHistory() {
        for dataPoint in diceVM.diceRollList {
            print("Rounds: \(dataPoint.rounds)")
            print("Size: \(dataPoint.diceSize)")
            print("Date: \(diceVM.formatDate(date: dataPoint.date))")
            for (index, numb) in dataPoint.numbers.enumerated() {
                print("\(index): \(numb)")
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        diceVM.diceRollList.remove(atOffsets: offsets)
        diceVM.save()
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
