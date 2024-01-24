//
//  LeaderboardEntry.swift
//  Game2048
//
//  Created by Charlie Parker on 1/23/24.
//

import Foundation

struct LeaderboardEntry: Decodable {
    let username: String
    let score: Int
    let date: String
}
