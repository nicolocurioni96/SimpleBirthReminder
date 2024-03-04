//
//  SimpleBirthReminderApp.swift
//  SimpleBirthReminder
//
//  Created by Nicolò Curioni on 04/03/24.
//

import SwiftUI
import SwiftData

@main
struct SimpleBirthReminderApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Birthday.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
