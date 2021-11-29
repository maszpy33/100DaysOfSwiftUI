//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Andreas Zwikirsch on 27.11.21.
//

import SwiftUI

@main
struct BookwormApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
