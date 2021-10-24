//
//  SettingsView.swift
//  edutainment
//
//  Created by Andreas Zwikirsch on 21.10.21.
//

import Foundation
import SwiftUI



struct SettingsView: View {
    @Binding var questionsTotal: Int
    @Binding var difficultyLevel: Int
    
    let difficulties = ["Easy", "Medium", "Hard", "RWTH"]
    
    @State private var speakingBubbleText = "Hello young mathematician! I am the Settings-Whale Fin"
    
    
    var body: some View {
        VStack(spacing: 30){
            
            HStack{
                Image("whale_fin")
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .white, radius: 8)
                    .frame(width: 100, height: 100, alignment: .leading)
                ZStack{
                    Image("speakingBubble2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190, height: 120, alignment: .top)
                    Text("\(speakingBubbleText)")
                        .foregroundColor(.black)
                        .font(.system(size: 15, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 90, alignment: .center)
                }
            }
            
            
            Form {
                Text("Settings:")
                    .font(.title)
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
                    ForEach(1..<21) {
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
//        SettingsView(questionCount: questionsTotal, $difficultyLevel: $difficultyLevel).preferredColorScheme(.dark)
//    }
//}

