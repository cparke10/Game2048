//
//  ContentView.swift
//  Game2048
//
//  Created by Charlie Parker on 1/19/24.
//

import SwiftUI

struct LandingPage: View {
    
    static let headerSpacerHeight: CGFloat = 30
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height: Self.headerSpacerHeight)
                BoardView()
                Spacer()
                LeaderboardButton()
            }
        }
    }
}
