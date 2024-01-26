//
//  LeaderboardService.swift
//  Game2048
//
//  Created by Charlie Parker on 1/23/24.
//

import Foundation

/// Manges requests to the leaderboard API.
class LeaderboardService {
    private let baseURL = "https://www.google.com/" // TODO: replace with LeaderboardServer url
    private var userId: String? { UserManager.shared.user?.id }
    
    /// Performs the leaderboard API request for the list of entries.
    /// - Parameters:
    ///   - type: The `LeaderboardType` to request the API for.
    ///   - completionHandler: The completion block to handle the service response.
    func requestLeaderboard(for type: LeaderboardType, completionHandler: @escaping (Result<[LeaderboardEntry], Error>) -> Void) {
        guard let userId, let url = URL(string: "\(baseURL)\(type == .me ? userId : "")") else { return }
        
        URLRequest.request(URLRequest(url: url), responseType: [LeaderboardEntry].self, completionHandler: completionHandler)
    }
    
    /// Performs the leaderboard API request to submit an entry based on the score.
    /// - Parameters:
    ///   - score: The game score to upload to the API.
    ///   - completionHandler: The completion block to handle the service response.
    func submitEntry(score: Int, completionHandler: @escaping (Result<SubmissionResponse, Error>) -> Void) {
        guard let userId, let url = URL(string: baseURL) else { return }
        
        let entry = LocalLeaderboardEntry(id: userId, score: score)
        guard let body = try? JSONEncoder().encode(entry) else { return }
        
        var submitRequest = URLRequest(url: url)
        submitRequest.httpMethod = URLRequest.HTTPMethod.put.rawValue
        submitRequest.httpBody = body
        URLRequest.request(submitRequest, responseType: SubmissionResponse.self, completionHandler: completionHandler)
    }
}
