//
//  MissionView.swift
//  Moonshot
//
//  Created by Andreas Zwikirsch on 30.10.21.
//

import SwiftUI

extension View {
    func rotateImage(using animation: Animation = .easeOut(duration: 1), _ action: @escaping () -> Void) -> some View {
        onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }
}


struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let astronauts: [CrewMember]
    
    @State private var switchDateOrCrew = true
    
    @State private var scale: CGFloat = 0
    
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        for member in mission.crew {
            if let match = astronauts.first(where: {$0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member)")
            }
        }
        
        self.astronauts = matches
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.7)
                        .padding(.top)
                        .scaleEffect(scale)
                        .rotateImage() { scale = 1 }
                    
                    // Challenge 1 & Challenge 3
                    ZStack {
                        Text(self.switchDateOrCrew ? "Mission launched: \(mission.formattedLaunchDate)" : "Crew: \(mission.crewNames)")
                            .padding()
                            .opacity(self.switchDateOrCrew ? 1 : 0)
                            .offset(x: self.switchDateOrCrew ? 0 : -250)
//                            .animation(self.switchDateOrCrew ? .easeIn(duration: 1) : .easeOut(duration: 1))
                            .animation(.linear)
                        Text(self.switchDateOrCrew ? "Mission launched: \(mission.formattedLaunchDate)" : "Crew: \(mission.crewNames)")
                            .padding()
                            .opacity(self.switchDateOrCrew ? 0 : 1)
                            .offset(x: self.switchDateOrCrew ? 250 : 0)
//                            .animation(self.switchDateOrCrew ? .easeOut(duration: 1) : .easeIn(duration: 1))
                            .animation(.linear)
                    }
                    
                    
                    Text(self.mission.description)
                        .padding()
                    
                    ForEach(self.astronauts, id: \.role) { crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut)) {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(crewMember.role == "Commander" ? Color.orange : Color.primary, lineWidth: 1))
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundColor(crewMember.role == "Commander" ? .orange : .secondary)
                                }
                                
                                Spacer()
                                
                                Label("icon only", systemImage: "info.circle")
                                    .labelStyle(.iconOnly)
                                    .font(.title3)
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
        // Challenge 3
        .navigationBarItems(trailing:
                                Button(action: {
            self.switchDateOrCrew.toggle()
        }) {
            Text(self.switchDateOrCrew ? "👨🏻‍🚀 Crew" : "🚀 Launche Date")
//            Image(systemName: "switch.2")
        })
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
    }
}
