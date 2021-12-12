//
//  ContentView.swift
//  UserList
//
//  Created by Andreas Zwikirsch on 10.12.21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var users = Users()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users.allUsers) { user in
                    NavigationLink {
                        DetailsView(user: user)
                    } label: {
                        HStack {
                            VStack {
                                Image(systemName: "icloud.circle.fill")
                                    .foregroundColor(user.isActive ? .green : .red)
    //                            Text(user.isActive ? "online" : "offline")
    //                                .font(.system(size: 7))
                            }
                            Text(user.name)
                        }
                    }
                }
            }
            .navigationTitle("User List")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let james = User(id: "007", isActive: false, name: "James Bond", age: 42, company: "MI6", email: "james.bond.007@agent.com", address: "London", friends: [])
    
    static var previews: some View {
        ContentView(users: Users(users: [james]))
    }
}
