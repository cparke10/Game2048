//
//  Game2048App.swift
//  Game2048
//
//  Created by user253524 on 1/19/24.
//

import SwiftUI
import SwiftData

@main
struct Game2048App: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init())
        }
    }
}
