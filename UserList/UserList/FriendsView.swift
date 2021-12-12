//
//  FriendsView.swift
//  UserList
//
//  Created by Andreas Zwikirsch on 12.12.21.
//

import SwiftUI

struct FriendsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let friends: [Friend]

    var body: some View {
        NavigationView {
            List {
                ForEach(friends) { friend in
                    Text(friend.name)
                }
            }
        }
        .navigationBarItems(
            trailing:
                Button("Dismiss") {
                    self.presentationMode.wrappedValue.dismiss()
                })
    }
}

//struct FriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsView()
//    }
//}
