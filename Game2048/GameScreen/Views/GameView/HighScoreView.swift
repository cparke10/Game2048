//  HighScoreLabel.swift
//  Game2048
//
//  Created by Charlie Parker on 1/19/24.
//

import SwiftUI

/// The view used to represent the stats button.
struct HighScoreLabel: View {
    private let score: Int
    
    /// Container for the constants used in the view
    private struct ViewConstants {
        static let scoreKey = NSLocalizedString("Score", comment: "High score label key content")
        static let scoreKeyFontSize: CGFloat = 32
        static let scoreFontSize: CGFloat = 40
        static let backgroundCornerRadius: CGFloat = 12
    }
    
    init(score: Int) { self.score = score }
    
    var body: some View {
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
        .background(
            RoundedRectangle(cornerRadius: ViewConstants.backgroundCornerRadius)
                    .fill(GameColors.color9)
                )
    }
}
