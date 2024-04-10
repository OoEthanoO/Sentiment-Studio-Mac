//
//  Sentiment_StudioApp.swift
//  Sentiment Studio
//
//  Created by Ethan Xu on 2024-03-30.
//

import SwiftUI
import SwiftData

@main
struct Sentiment_StudioApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.appInfo) {
                Button(action: {
                    appDelegate.showAboutPanel()
                }) {
                    Text("About Sentiment Studio")
                }
            }
        }
        
        Window("Version History", id: "version-history") {
            VersionHistoryView()
        }
        .windowResizability(.contentSize)
    }
}
