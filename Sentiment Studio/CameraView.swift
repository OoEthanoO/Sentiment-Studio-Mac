//
//  CameraView.swift
//  Sentiment Studio
//
//  Created by Ethan Xu on 2024-04-07.
//

import SwiftUI

struct CameraView: NSViewControllerRepresentable {
    
    typealias NSViewControllerType = ViewController
    
    func makeNSViewController(context: NSViewControllerRepresentableContext<CameraView>) -> ViewController {
        return ViewController()
    }

    func updateNSViewController(_ uiViewController: ViewController, context: NSViewControllerRepresentableContext<CameraView>) {
        // Leave this empty
    }
}

#Preview {
    CameraView()
}
