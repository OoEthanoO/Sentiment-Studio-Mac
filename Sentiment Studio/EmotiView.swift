//
//  EmotiView.swift
//  Sentiment Studio
//
//  Created by Ethan Xu on 2024-04-05.
//

import SwiftUI
import AVKit

struct EmotiView: View {
    var body: some View {
        VStack {
            TitleView(text: "Emotion Predictor")
            CameraView()
        }
    }
}

#Preview {
    EmotiView()
}
