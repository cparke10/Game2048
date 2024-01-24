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

/// A specifc leaderboard within the `LeaderboardTabView`. Displays a list of leaderboard entries tied to the specified `LeaderboardType`.
fileprivate struct LeaderboardView: View {
    let type: LeaderboardType
    private let service = LeaderboardService()
    @State private var leaderboardResponse: Result<LeaderboardData, Error>?
    
    private static let errorString = NSLocalizedString("", comment: "Leaderboard error state content")
    
    var body: some View {
        VStack {
            switch leaderboardResponse {
            case .success(let leaderboard): loadedView(for: leaderboard)
            case .failure: errorView
            case nil:
                ProgressView()
                    .onAppear {
                        requestLeaderboard(with: type)
                    }
            }
        }
    }
    
    /// Requests the `LeaderboardService` using the given `LeaderboardType` and updates the view state using the response.
    /// - Parameter type: The `LeaderboardType` to request.
    private func requestLeaderboard(with type: LeaderboardType) {
        service.request(with: type) { result in
            leaderboardResponse = result
        }
    }
}

fileprivate extension LeaderboardView {
    
    /// Constructs and returns a list of leaderboard entries reflecting the given `LeaderboardData`.
    /// - Parameter leaderboard: The `LeaderboardData` to display.
    /// - Returns: A `List` view containing the data.
    func loadedView(for leaderboard: LeaderboardData) -> some View {
        Section {
            List(leaderboard) { entry in
                HStack {
                    VStack(alignment: .leading) {
                        Text(entry.date)
                            .foregroundStyle(.gray)
                            .font(.caption)
                        HStack {
                            Circle()
                                .fill(GameColors.color11)
                                .fixedSize()
                            Text(String(entry.score))
                                .foregroundStyle(GameColors.color11)
                                .font(.largeTitle)
                                .bold()
                        }
                    }
                    Spacer()
                    Text(entry.username)
                        .foregroundStyle(GameColors.color8)
                        .font(.headline)
                }
            }
        } header: {
            let icon = type.tabAttributes.icon
            Label(type.sectionTitle, systemImage: icon)
        }
    }
    
    /// The error view used for the leaderboard.
    var errorView: some View {
        VStack {
            Spacer()
            Label(Self.errorString, systemImage: "three.by.three.badge.xmark")
            Spacer()
            Spacer()
            Spacer()
        }
    }
}
