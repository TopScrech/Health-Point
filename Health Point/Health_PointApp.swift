//
//  Health_PointApp.swift
//  Health Point
//
//  Created by Sergei Saliukov on 12/07/2023.
//

import SwiftUI
import SwiftData

@main
struct Health_PointApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
