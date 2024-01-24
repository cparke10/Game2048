//  GameInterfaceStack.swift
//  Game2048
//
//  Created by Charlie Parker on 1/19/24.
//

import SwiftUI

/// The view used to represent the game interface elements outside the board. Contains the score label and reset button.
struct GameInterfaceStack: View {
    @ObservedObject var boardViewModel: BoardViewModel
    
    /// Container for the constants used in the view
    private struct ViewConstants {
        static let scoreKey = NSLocalizedString("Score", comment: "High score label key content")
        static let scoreKeyFontSize: CGFloat = 32
        static let scoreFontSize: CGFloat = 40
        static let resetImageName = "arrow.clockwise"
        static let spacing: CGFloat = 6
    }
    
    var body: some View {
        VStack(spacing: ViewConstants.spacing) {
            scoreLabel(with: boardViewModel.score)
            resetButton
        }
    }
}

fileprivate extension GameInterfaceStack {
    /// Constructs and returns a stack of labels used to represent the score.
    /// - Parameter score: The score used to configure the view.
    /// - Returns: A view for the score.
    func scoreLabel(with score: Int) -> some View {
        HStack {
            Text(ViewConstants.scoreKey)
                .font(.system(size: ViewConstants.scoreKeyFontSize))
                .padding(.trailing)
                .foregroundColor(.gray)
            Text(String(score))
                .font(.system(size: ViewConstants.scoreFontSize))
                .bold()
                .foregroundColor(.white)
        }
        .padding([.horizontal])
        .addRoundedBackground(color: GameColors.color9)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    /// The button used to reset the dependent view model.
    var resetButton: some View {
        Button {
            boardViewModel.reset()
        } label: {
            Image(systemName: ViewConstants.resetImageName)
                .font(.title)
                .foregroundStyle(.white)
                .padding()
                .addRoundedBackground(color: GameColors.color5)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

fileprivate extension View {
    /// Modifies the given view to apply a rounded background using the corner radius and color.
    /// - Parameters:
    ///   - cornerRadius: The corner radius to use for the background.
    ///   - color: The color to use for the background.
    /// - Returns: The modified `View` with the background.
    @ViewBuilder func addRoundedBackground(color: Color) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
        )
    }
}
