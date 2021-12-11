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
                    Text(user.name)
                }
            }
            .navigationTitle("User List")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let james = User(id: "007", name: "James Bond", age: 42, company: "MI6", email: "james.bond.007@agent.com", address: "London", friends: [])
    
    static var previews: some View {
        ContentView(users: Users(users: [james]))
    }
}
