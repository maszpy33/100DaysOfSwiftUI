//
//  StatisticsView.swift
//  RollTheDice
//
//  Created by Andreas Zwikirsch on 02.10.22.
//

import SwiftUI

struct StatisticsView: View {
    
    @EnvironmentObject var diceVM: DiceViewModel
    
    var body: some View {
        Text("StatisticsView")
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
