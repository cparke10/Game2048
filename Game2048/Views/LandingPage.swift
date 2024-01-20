//
//  ContentView.swift
//  Game2048
//
//  Created by user253524 on 1/19/24.
//

import SwiftUI
import SwiftData
import UIKit

struct LandingPage: View {
    
    static let headerSpacerHeight: CGFloat = 30
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer().frame(height: Self.headerSpacerHeight)
                BoardView()
                Spacer()
                LeaderboardButton()
            }
        }
    }
}
