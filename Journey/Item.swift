//
//  Item.swift
//  Journey
//
//  Created by Caleb Elson on 4/30/24.
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
