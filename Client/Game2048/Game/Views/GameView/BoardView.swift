//
//  BoardView.swift
//  Game2048
//
//  Created by Charlie Parker on 1/19/24.
//

import SwiftUI

/// The view used to represent the game board.
struct BoardView: View {
    @StateObject var viewModel: BoardViewModel = .init()
    private let service = LeaderboardService()

    /// Container for the constants used in the view
    private struct ViewConstants {
        static let rowPadding: CGFloat = 2
        static let boardSize: CGFloat = 300
        static let boardPadding: CGFloat = 10
        static let boardCornerRadius: CGFloat = 10
        static let gameOverTitleString = NSLocalizedString("Game Over!", comment: "Game over alert title content")
        static let gameOverMessageString = NSLocalizedString("You scored: %@", comment: "Game over alert message content")
        static let gameOverSubmitString = NSLocalizedString("Submit", comment: "Game over submit button content")
        static let gameOverOkString = NSLocalizedString("OK", comment: "OK alert button content")
    }
    
    /// The gesture which handles swipe actions on the board by updating the view model.
    private var boardSwipe: some Gesture {
        DragGesture()
            .onEnded {
                let xDelta = $0.location.x - $0.startLocation.x
                let yDelta = $0.location.y - $0.startLocation.y
                
                let currSwipe: BoardModel.CollapseDirection
                if abs(xDelta) > abs(yDelta) {
                    currSwipe = xDelta < 0 ? .left : .right
                } else {
                    currSwipe = yDelta < 0 ? .up : .down
                }
                
                viewModel.collapse(direction: currSwipe)
            }
    }
    
    var body: some View {
        VStack {
            tileMatrixStack(tileViewModels: viewModel.tileViewModels)
                .gesture(boardSwipe)
            Spacer()
                .frame(height: ViewConstants.boardPadding)
            GameInterfaceStack(viewModel: GameInterfaceStackViewModel(score: viewModel.score, resetCallback: viewModel.reset))
        }
        .alert(isPresented: $viewModel.isPresentingGameOverAlert) { gameOverAlert }
        .fixedSize(horizontal: true, vertical: false) // horizontally align interface stack with tile matrix stack
    }
}

extension BoardView {
    /// Constructs and returns a 2D view matrix for the tile view models.
    /// - Parameter tileViewModels: The 2D array of `TileViewModel` used to configure the view.
    /// - Returns: A 2D view matrix for the tiles.
    func tileMatrixStack(tileViewModels: [[TileViewModel]]) -> some View {
        VStack {
            ForEach(viewModel.tileViewModels, id: \.self) { row in
                HStack {
                    ForEach(row) { tileViewModel in
                        TileView(viewModel: tileViewModel)
                    }
                }
                .padding(ViewConstants.rowPadding)
            }
        }
        .frame(width: ViewConstants.boardSize, height: ViewConstants.boardSize)
        .padding(ViewConstants.boardPadding)
        .background(Color.gray.cornerRadius(ViewConstants.boardCornerRadius))
        .setAccessibilityAttributes(label: viewModel.tilesAccessibilityLabel)
        .accessibilityElement().accessibilityLabel(viewModel.tilesAccessibilityLabel)
    }
    
    /// The `Alert` used for the game over scenario. Displays the final game score and allows for score submission to the leaderboard.
    var gameOverAlert: Alert {
        Alert(title: Text(ViewConstants.gameOverTitleString),
              message: Text(String(format: ViewConstants.gameOverMessageString, String(viewModel.score))),
              primaryButton: .cancel(Text(ViewConstants.gameOverOkString)),
              secondaryButton: .default(Text(ViewConstants.gameOverSubmitString)) {
            service.submitEntry(score: viewModel.score) { _ in } // fire and forget score submission
        })
    }
}
