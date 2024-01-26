//
//  LeaderboardEntry.swift
//  Game2048
//
//  Created by Charlie Parker on 1/23/24.
//

import Foundation

protocol LeaderboardEntryProtocol {
    var score: Int { get }
}

/// Represents a local entry to the leaderboard made by a user.
struct LocalLeaderboardEntry: Encodable, LeaderboardEntryProtocol {
    let id: String
    let score: Int
}

/// Represents an entry to the leaderboard from the API, including the matched username and server date.
struct LeaderboardEntry: Decodable, LeaderboardEntryProtocol {
    let username: String
    let score: Int
    let date: String
}
