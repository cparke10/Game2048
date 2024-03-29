//  GameInterfaceStack.swift
//  Game2048
//
//  Created by Charlie Parker on 1/19/24.
//

import SwiftUI

/// The view used to represent the game interface elements outside the board. Contains the score label and reset button.
struct GameInterfaceStack: View {
    let viewModel: GameInterfaceStackViewModel
    
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
            scoreLabel
            resetButton
        }
    }
}

fileprivate extension GameInterfaceStack {
    /// The label used to reflect the game score.
    var scoreLabel: some View {
        HStack {
            Text(ViewConstants.scoreKey)
                .font(.system(size: ViewConstants.scoreKeyFontSize))
                .padding(.trailing)
                .foregroundColor(.gray)
            Text(String(viewModel.score))
                .font(.system(size: ViewConstants.scoreFontSize))
                .bold()
                .foregroundColor(.white)
        }
        .padding([.horizontal])
        .addRoundedBackground(color: GameColors.color9)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    /// The button used to reset the view model through the callback to the parent view model.
    var resetButton: some View {
        Button {
            viewModel.resetCallback()
        } label: {
            Image(systemName: ViewConstants.resetImageName)
                .font(.title)
                .foregroundStyle(.white)
                .padding()
                .addRoundedBackground(color: GameColors.color5)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .setAccessibilityAttributes(label: viewModel.resetAccessibilityLabel, hint: viewModel.resetAccesibilityHint)
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
