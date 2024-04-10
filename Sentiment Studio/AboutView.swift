//
//  AboutView.swift
//  Sentiment Studio
//
//  Created by Ethan Xu on 2024-04-03.
//

import SwiftUI

struct AboutView: View {
    let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    let buildVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
    
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        let versionText = "Version " + (appVersion ?? "NULL") + " (Build " + (buildVersion ?? "NULL") + ")"
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    Text("Sentiment Studio")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                    Text(versionText)
                        .padding(.bottom, 10)
                    Text("By Ethan Yan Xu")
                        .fontWeight(.bold)
                    Button("Version History") {
                        openWindow(id: "version-history")
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .frame(minWidth: 300, minHeight: 300)
    }
}

#Preview {
    AboutView()
}
