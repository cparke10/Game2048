//
//  LeaderboardButton.swift
//  Game2048
//
//  Created by Charlie Parker on 1/19/24.
//

import SwiftUI

/// The view used to represent the leaderboard navigation button.
struct LeaderboardButton: View {
    
    /// Container for the constants used in the view
    private struct ViewConstants {
        static let backgroundColor = Color(red: 211/255, green: 211/255, blue: 211/255)
        static let buttonTitleString = NSLocalizedString("Leaderboard", comment: "Leaderboard navigation button content")
        static let buttonTitleFontSize: CGFloat = 18
        static let buttonBackgroundCornerRadius: CGFloat = 12
        static let buttonBackgroundCornerWidth: CGFloat = 2
    }
    
    var body: some View {
        ZStack {
            HStack {
                NavigationLink(destination: LandingPage()) {
                    Text(ViewConstants.buttonTitleString)
                        .font(.system(size: ViewConstants.buttonTitleFontSize))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: ViewConstants.buttonBackgroundCornerRadius)
                                .stroke(Color.blue, lineWidth: ViewConstants.buttonBackgroundCornerWidth)
                                .fill(Color.white)
                        )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .overlay(Divider().background(Color.blue), alignment: .top)
        .background(ViewConstants.backgroundColor)
    }
}
