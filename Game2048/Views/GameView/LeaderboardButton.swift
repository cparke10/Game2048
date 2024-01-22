//
//  LeaderboardButton.swift
//  Game2048
//
//  Created by Charlie Parker on 1/19/24.
//

import SwiftUI

/// The view used to represent the leaderboard navigation button.
struct LeaderboardButton: View {
    
    private static let backgroundColor = Color(red: 211/255, green: 211/255, blue: 211/255)
    private static let buttonTitleString = NSLocalizedString("Leaderboard", comment: "Leaderboard navigation button content")
    
    var body: some View {
        ZStack {
            HStack {
                NavigationLink(destination: LandingPage()) {
                    Text(Self.buttonTitleString)
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue, lineWidth: 2)
                                .fill(Color.white)
                        )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .overlay(Divider().background(Color.blue), alignment: .top)
        .background(Self.backgroundColor)
    }
}
