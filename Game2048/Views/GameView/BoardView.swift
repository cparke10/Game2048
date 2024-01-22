//
//  BoardView.swift
//  Game2048
//
//  Created by Charlie Parker on 1/19/24.
//

import SwiftUI

/// The view used to represent the game board.
struct BoardView: View {
    @ObservedObject var viewModel: BoardViewModel = .init()
    @State private var spawnScale: Double = 1
    private let gameOverTitleString = NSLocalizedString("Game Over!", comment: "Game over alert title content")
    private let okString = NSLocalizedString("OK", comment: "OK alert button content")
    
    /// Container for the constants used in the view
    private struct ViewConstants {
        static let rowPadding: CGFloat = 2
        static let boardSize: CGFloat = 300
        static let boardPadding: CGFloat = 10
        static let boardCornerRadius: CGFloat = 10
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
            ForEach(viewModel.tileViewModels, id: \.self) { row in
                HStack {
                    ForEach(row) { tileViewModel in
                        TileView(viewModel: tileViewModel)
                    }
                }
                .padding(ViewConstants.rowPadding)
            }
            HStack {
                Spacer()
                HighScoreLabel(score: viewModel.score)
                    .padding()
            }
        }
        .frame(width: ViewConstants.boardSize, height: ViewConstants.boardSize)
        .padding(ViewConstants.boardPadding)
        .background(Color.gray.cornerRadius(ViewConstants.boardCornerRadius))
        .gesture(boardSwipe)
        .alert(gameOverTitleString, isPresented: Binding<Bool>(
            get: { viewModel.isPresentingGameOverAlert },
            set: { _ in viewModel.isPresentingGameOverAlert = false }
        )) {
            Button(okString, role: .cancel) { }
        }
    }
}
