//
//  DEXApp.swift
//  DEX
//
//  Created by Oleh on 11.04.2025.
//

import SwiftUI

@main
struct DEXApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
