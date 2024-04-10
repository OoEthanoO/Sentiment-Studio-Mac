//
//  SpaceTextView.swift
//  Sentiment Studio
//
//  Created by Ethan Xu on 2024-04-03.
//

import SwiftUI

struct SpaceTextView: View {
    var text: String
    var bold: Bool?
    var body: some View {
        Text(text)
            .padding(.bottom, 10)
            .fontWeight(bold ?? false ? .bold : .none)
    }
}

#Preview {
    SpaceTextView(text: "Sample Text")
}
