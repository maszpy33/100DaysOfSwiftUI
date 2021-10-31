//
//  AstronautView.swift
//  Moonshot
//
//  Created by Andreas Zwikirsch on 30.10.21.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    let missions: [Mission]
    
    // Challenge 2
    init(astronaut: Astronaut) {
        self.astronaut = astronaut
        
        let allMissions: [Mission] = Bundle.main.decode("missions.json")
        
        // COPY FROM ANOTHER GITHUB
        missions = allMissions.filter { $0.crew.map { $0.name }.contains(astronaut.id) }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                    
                    Text(self.astronaut.description)
                        .padding()
                    
                    Text("Participated missions:")
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(x: 10)
                    
                    HStack {
                        ForEach(self.missions) { mission in
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                Text("Apollo \(mission.id)")
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}
