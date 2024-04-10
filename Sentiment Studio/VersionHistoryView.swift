//
//  VersionHistoryView.swift
//  Sentiment Studio
//
//  Created by Ethan Xu on 2024-04-03.
//

import SwiftUI

struct VersionHistoryView: View {
    var body: some View {
        VStack(alignment: .leading) {
            SpaceTextView(text: "Date Uploaded: 04/05/2024")
            SpaceTextView(text: "Version: 0.1")
            SpaceTextView(text: "Version Highlights:")
            Text("0.1")
                .bold()
            SpaceTextView(text: "   -   Proof of concept")
        }
    }
}

#Preview {
    VersionHistoryView()
}
