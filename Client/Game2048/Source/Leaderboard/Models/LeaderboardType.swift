//
//  LeaderboardType.swift
//  Game2048
//
//  Created by Charlie Parker on 1/23/24.
//

import Foundation

/// Represents the type of the leaderboard: either a personal or global leaderboard.
enum LeaderboardType: Int {
    private struct Constants {
        // MARK: Tab constants
        static let meString = NSLocalizedString("Me", comment: "Me leaderboard tab item title")
        static let globalString = NSLocalizedString("Global", comment: "Global leaderboard tab item title")
        
        // MARK: Section constants
        static let mySectionString = NSLocalizedString("My leaderboard", comment: "Me leaderboard section title")
        static let globalSectionString = NSLocalizedString("Global leaderboard", comment: "Global leaderboard section title")
                                                
    }
    
    case me = 0, global
    
    var tabAttributes: (title: String, icon: String) {
        switch self {
        case .me: return (title: Constants.meString, icon: "person")
        case .global: return (title: Constants.globalString, icon: "globe")
        }
    }
    
    var sectionTitle: String {
        switch self {
        case .me: return Constants.mySectionString
        case .global: return Constants.globalSectionString
        }
    }
}
