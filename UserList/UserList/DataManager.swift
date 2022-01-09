//
//  DataManager.swift
//  UserList
//
//  Created by Andreas Zwikirsch on 10.01.22.
//

import Foundation
import CoreData

struct DataManager {
    
    static func loadData(moc: NSManagedObjectContext) {
        DispatchQueue.global().async {
            fetchData { users in
                // moc comes from the main thread
                DispatchQueue.main.async {
                    // store to add friends in 2 passes
                    var tempUsers = [User]()
                    
                    for user in users {
                        let newUser = User(context: moc)
                        newUser.id = user.id
                        newUser.name = user.name
                        newUser.age = user.age
                        newUser.email = user.email
                        newUser.address = user.address
                        
                        let company = Company(context: moc)
                        company.name = user.company
                        newUser.company = company
                        
                        tempUsers.append(newUser)
                    }
                }
            }
        }
    }
    
    static func fetchData(completion: @escaping ([JSONUser]) -> ()) {
        print("Fetching data...")
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        let session = URLSession.shared.dataTask(with: request) { data, response, sessionError in
            guard let data = data else {
                print("Fetch failed: \(sessionError?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode([JSONUser].self, from: data)
                
                completion(decoded)
            }
            catch let decodingError {
                print("Decoding failed: \(decodingError.localizedDescription)")
            }
            
            session.resume()
        }
    }
}
