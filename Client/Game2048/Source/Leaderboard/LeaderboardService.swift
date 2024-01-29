//
//  LeaderboardService.swift
//  Game2048
//
//  Created by Charlie Parker on 1/23/24.
//

import Foundation

/// Manges requests to the leaderboard API.
class LeaderboardService {

    /// The `Game2048URLRequest` used to request the leaderboard for some `LeaderboardType`.
    private struct GetLeaderboardRequest: Game2048URLRequest {
        var pathComponent: String { "leaderboard/\(type == .me ? UserManager.shared.user?.id ?? "" : "")" }
        let method = HTTPMethod.get
        let body: Data? = nil
        let type: LeaderboardType
    }
    
    /// The `Game2048URLRequest` used to submit entries to the leaderboard.
    private struct SubmitLeaderboardEntryRequest: Game2048URLRequest {
        let pathComponent = "leaderboard"
        let method = HTTPMethod.put
        let body: Data?
    }
    
    /// Performs the leaderboard API request for the list of entries.
    /// - Parameters:
    ///   - type: The `LeaderboardType` to request the API for.
    ///   - completionHandler: The completion block to handle the service response.
    func requestLeaderboard(for type: LeaderboardType, completionHandler: @escaping (Result<LeaderboardResponse, Error>) -> Void) {
        URLRequest.request(GetLeaderboardRequest(type: type), responseType: LeaderboardResponse.self, completionHandler: completionHandler)
    }
    
    /// Performs the leaderboard API request to submit an entry based on the score.
    /// - Parameters:
    ///   - score: The game score to upload to the API.
    ///   - completionHandler: The completion block to handle the service response.
    func submitEntry(score: Int, completionHandler: @escaping (Result<SubmissionResponse, Error>) -> Void) {
        guard let body = try? JSONEncoder().encode(LocalLeaderboardEntry(score: score)) else { return }
        
        URLRequest.request(SubmitLeaderboardEntryRequest(body: body), responseType: SubmissionResponse.self, completionHandler: completionHandler)
    }
}
