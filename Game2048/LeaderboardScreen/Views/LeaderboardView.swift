//
//  LeaderboardView.swift
//  Game2048
//
//  Created by user253524 on 1/23/24.
//

import SwiftUI

/// A specifc leaderboard within the `LeaderboardTabView`. Displays a list of leaderboard entries tied to the specified `LeaderboardType`.
struct LeaderboardView: View {
    
    @ObservedObject private var viewModel: LeaderboardViewModel
    private let service = LeaderboardService()
    
    private static let errorString = NSLocalizedString("We're sorry, we had trouble loading the leaderboard. Please come back later",
                                                       comment: "Leaderboard error state content")
    
    init(viewModel: LeaderboardViewModel) { self.viewModel = viewModel }
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loaded(let entryViewModels): loadedView(for: entryViewModels)
            case .error: errorView
            case .loading:
                ProgressView()
                    .onAppear {
                        requestLeaderboard()
                    }
            }
        }
    }
    
    /// Requests the `LeaderboardService` using the viewModel's type and updates the viewModel state with the result.
    private func requestLeaderboard() {
        service.requestLeaderboard(for: viewModel.type) { result in
            DispatchQueue.main.async {
                self.viewModel.update(with: result)
            }
        }
    }
}

fileprivate extension LeaderboardView {
    
    /// Constructs and returns a list of leaderboard entries reflecting the given `LeaderboardData`.
    /// - Parameter leaderboard: The `LeaderboardData` to display.
    /// - Returns: A `List` view containing the data.
    func loadedView(for leaderboard: [LeaderboardEntryViewModel]) -> some View {
        Section {
            List(leaderboard) { entry in
                HStack {
                    VStack(alignment: .leading) {
                        Text(entry.date)
                            .foregroundStyle(.gray)
                            .font(.caption)
                        HStack {
                            Text(String(entry.rank))
                                .padding()
                                .background {
                                    Circle()
                                        .stroke(GameColors.color4, lineWidth: 4)
                                }
                            Text(String(entry.username))
                                .foregroundStyle(GameColors.color11)
                                .font(.largeTitle)
                        }
                    }
                    Spacer()
                    Text(String(entry.score))
                        .foregroundStyle(GameColors.color11)
                        .font(.largeTitle)
                        .bold()
                }
            }
        } header: {
            let icon = viewModel.type.tabAttributes.icon
            Label(viewModel.type.sectionTitle, systemImage: icon)
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
