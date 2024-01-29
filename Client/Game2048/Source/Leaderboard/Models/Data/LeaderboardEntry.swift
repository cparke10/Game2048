//
//  LeaderboardEntry.swift
//  Game2048
//
//  Created by Charlie Parker on 1/23/24.
//

import Foundation

/// Represents a leaderboard entry containing a score field.
protocol LeaderboardEntryProtocol {
    var score: Int { get }
}


// MARK: Local data

/// Represents a local entry to the leaderboard made by a user.
struct LocalLeaderboardEntry: Encodable, LeaderboardEntryProtocol { let score: Int }

// MARK: API data

/// Represents an entry to the leaderboard from the API, including the matched username and server date.
struct LeaderboardEntry: LeaderboardEntryProtocol, Decodable {
    let username: String
    let score: Int
    let date: String
}

/// Represents the response from the leaderboard API.
struct LeaderboardResponse: Game2048ServiceResponse {
    typealias ModelData = [LeaderboardEntry]
    
    let data: ModelData
}
