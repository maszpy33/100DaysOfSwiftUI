//
//  TestCoreDateProjectApp.swift
//  TestCoreDateProject
//
//  Created by Andreas Zwikirsch on 10.12.21.
//

import SwiftUI

@main
struct TestCoreDateProjectApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
