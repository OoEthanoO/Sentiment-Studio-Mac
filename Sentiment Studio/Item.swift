//
//  Item.swift
//  Sentiment Studio
//
//  Created by Ethan Xu on 2024-03-30.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
