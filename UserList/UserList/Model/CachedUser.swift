//
//  JSONUser.swift
//  UserList
//
//  Created by Andreas Zwikirsch on 10.01.22.
//

import Foundation

struct CachedUser: Codable, Identifiable {
    var id: String
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var friends: [JSONFriend]
}
