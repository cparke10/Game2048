//
//  LeaderBoardTabView.swift
//  Game2048
//
//  Created by Charlie Parker on 1/23/24.
//

import SwiftUI

/// The TabView used for the leaderboard screen. Hosts the personal and global leaderboard as driven by the leaderboard API.
struct LeaderboardTabView: View {
    
    @State private var tabTag = 0
    
    var body: some View {
        TabView(selection: $tabTag) {
            leaderboardTab(.me)
            leaderboardTab(.global)
        }
    }
}

fileprivate extension LeaderboardTabView {
    
    /// Constructs and returns a `LeaderboardView` element for use in the TabView. Manages tab selection through the view tag.
    /// - Parameter type: The `LeaderboardType` to construct.
    /// - Returns: A `LeaderboardView` driven by the given type.
    func leaderboardTab(_ type: LeaderboardType) -> some View {
        let tabAttributes = type.tabAttributes
        return LeaderboardView(type: type)
            .tabItem {
                Label(tabAttributes.title, systemImage: tabAttributes.icon)
            }
            .tag(type.rawValue)
    }
}
