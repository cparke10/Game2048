//
//  ContentView.swift
//  Game2048
//
//  Created by Charlie Parker on 1/19/24.
//

import SwiftUI

struct LandingPage: View {
    
    @StateObject private var viewModel: BoardViewModel = .init()
    static let headerSpacerHeight: CGFloat = 30
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer().frame(height: Self.headerSpacerHeight)
                BoardView(viewModel: viewModel)
                Spacer()
                StatsStack(viewModel: .init(statsDictionary: [.score: String(viewModel.score), .scorePerMinute: "0"]))
                LeaderboardButton()
            }
        }
    }
}
