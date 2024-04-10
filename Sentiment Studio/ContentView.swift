//
//  ContentView.swift
//  Sentiment Studio
//
//  Created by Ethan Xu on 2024-03-30.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink {
                    LSTMView()
                } label: {
                    Label("LSTM Sentiment Model", systemImage: "star.fill")
                        .tint(Color.yellow)
                }
                NavigationLink {
                    EmotiView()
                } label: {
                    Label("Emotion Recognition", systemImage: "star.fill")
                        .tint(Color.yellow)
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Projects")
        } detail: {
            Text("Choose a project from the sidebar")
        }
        .navigationTitle("Ethan's Project App")
    }
}

#Preview {
    ContentView()
}
