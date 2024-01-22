//  HighScoreLabel.swift
//  Game2048
//
//  Created by Charlie Parker on 1/19/24.
//

import SwiftUI

/// The view used to represent the stats button.
struct HighScoreLabel: View {
    private let score: Int
    private static let scoreKey = NSLocalizedString("Score", comment: "High score label key content")
    
    init(score: Int) {
        self.score = score
    }
    
    var body: some View {
        HStack {
            Text(Self.scoreKey)
                .font(.system(size: 18))
                .padding(.trailing)
            Text(String(score))
        }
        .padding()
        .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 237/255, green: 204/255, blue: 97/255))
                )
    }
}
