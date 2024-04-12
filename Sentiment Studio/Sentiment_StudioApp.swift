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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
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
