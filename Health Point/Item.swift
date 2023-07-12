//
//  Item.swift
//  Health Point
//
//  Created by Sergei Saliukov on 12/07/2023.
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
