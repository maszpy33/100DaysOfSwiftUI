//
//  SettingsView.swift
//  edutainment
//
//  Created by Andreas Zwikirsch on 21.10.21.
//

import Foundation
import SwiftUI



struct SettingsView: View {

    
    let difficulties = ["Easy", "Medium", "Hard", "RWTH"]

    
    @Binding var questionsTotal: Int
    @Binding var difficultyLevel: Int
    
    
    var body: some View {
        VStack(spacing: 30){
            Form {
                Text("Settings:")
                    .font(.largeTitle)
                    .bold()
                
                Text("Difficultie Level:")
                    .bold()
                Picker("Difficultie Level", selection: $difficultyLevel) {
                                        ForEach(0..<difficulties.count) {
                                            Text("\(self.difficulties[$0])")
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                
                Text("How many questions do you want to solve?")
                    .bold()
                
                Picker("How many questions do you want to solve?", selection: $questionsTotal) {
                    ForEach(1..<20) {
                        Text("\($0) questions")
                    }
                }
                .pickerStyle(.wheel)
                
            }
        }
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView(questionCount: self.$questionCount, difficultyLevel: self.$difficultyLevel).preferredColorScheme(.dark)
//    }
//}
