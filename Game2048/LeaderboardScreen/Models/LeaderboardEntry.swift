//
//  LeaderboardEntry.swift
//  Game2048
//
//  Created by Charlie Parker on 1/23/24.
//

import Foundation

typealias LeaderboardData = [LeaderboardEntry]

struct LeaderboardEntry: Decodable, Identifiable {
    let username: String
    let score: Int
    let date: String
    
    var id: String { username + date }
}
