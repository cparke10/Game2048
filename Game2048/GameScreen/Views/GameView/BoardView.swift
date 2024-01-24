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

    /// Container for the constants used in the view
    private struct ViewConstants {
        static let rowPadding: CGFloat = 2
        static let boardSize: CGFloat = 300
        static let boardPadding: CGFloat = 10
        static let boardCornerRadius: CGFloat = 10
        static let gameOverTitleString = NSLocalizedString("Game Over!", comment: "Game over alert title content")
        static let okString = NSLocalizedString("OK", comment: "OK alert button content")
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
            .alert(ViewConstants.gameOverTitleString, isPresented: $viewModel.isPresentingGameOverAlert) {
                Button(ViewConstants.okString, role: .cancel) { }
            }
            .gesture(boardSwipe)
            Spacer()
                .frame(height: ViewConstants.boardPadding)
            GameInterfaceStack(score: viewModel.score, resetCallback: viewModel.reset)
        }
        .fixedSize(horizontal: true, vertical: false) // horizontally align interface stack with tile matrix stack
    }
}

extension BoardView {
    /// Constructs and returns a 2D view matrix for the tiles.
    /// - Parameter tileViewModels: The 2dD array of `TileViewModel` used to configure the view.
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
    }
}
