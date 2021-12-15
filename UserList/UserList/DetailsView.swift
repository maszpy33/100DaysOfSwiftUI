//
//  DetailsView.swift
//  UserList
//
//  Created by Andreas Zwikirsch on 12.12.21.
//

import SwiftUI

struct FontModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
    }
}


struct DetailsView: View {
    let user: User
    
    @State private var showingSheet = false
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading) {
                GeometryReader { geo in
                    ZStack {
                        Image("SwiftBrain")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width)
                    }
                }
                
                Divider()
                
                VStack {
                    HStack {
                        Image(systemName: "doc.text.image")
                        Text(user.name)
                    }
                    .font(.title)
//                    Text("registered since: \(user.registered)")
                }
                
                
                Divider()
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "icloud.circle.fill")
                            .foregroundColor(user.isActive ? .green : .red)
                        Text("Status")
                    }
                    
                    Label("Age: \(user.age)",  systemImage: "number.circle.fill")
                    Label("E-Mail: \(user.email)", systemImage: "envelope.circle.fill")
                    Label("Company: \(user.company)", systemImage: "building.2.crop.circle")
                    Label("Address: \(user.address)", systemImage: "house.circle.fill")
                }
                .font(.title3)
                .padding()
                
                Divider()
                    .foregroundColor(.blue)
                
                Label("Friends", systemImage: "person.3.fill")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .font(.title3)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onTapGesture {
                        self.showingSheet.toggle()
                    }
                    .sheet(isPresented: $showingSheet) {
                        FriendsView(friends: user.friends)
                    }
                
                Spacer()
            }
            .navigationTitle("User Details View")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//struct DetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailsView()
//    }
//}
