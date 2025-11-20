//
//  BalanceTrackAIApp.swift
//  BalanceTrackAI
//
//  Created by AI Assistant
//  An intelligent expense tracker with Apple Intelligence
//

import SwiftUI
import SwiftData

@main
struct BalanceTrackAIApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Transaction.self,
            FinancialInsight.self
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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
