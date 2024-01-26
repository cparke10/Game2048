//
//  LeaderboardService.swift
//  Game2048
//
//  Created by Charlie Parker on 1/23/24.
//

import Foundation

/// Manges requests to the leaderboard API.
class LeaderboardService {
    private let baseURLString = "https://www.google.com" // TODO: replace with LeaderboardServer url
    private var userURLString: String? {
        guard let userId = UserManager.shared.user?.id else { return nil }
        
        return "\(baseURLString)/\(userId)"
    }
    
    /// Performs the leaderboard API request for the list of entries.
    /// - Parameters:
    ///   - type: The `LeaderboardType` to request the API for.
    ///   - completionHandler: The completion block to handle the service response.
    func requestLeaderboard(for type: LeaderboardType, completionHandler: @escaping (Result<LeaderboardResponse, Error>) -> Void) {
        guard let urlString = type == .me ? userURLString : baseURLString, let url = URL(string: urlString) else { return }
        
        URLRequest.request(URLRequest(url: url), responseType: LeaderboardResponse.self, completionHandler: completionHandler)
    }
    
    /// Performs the leaderboard API request to submit an entry based on the score.
    /// - Parameters:
    ///   - score: The game score to upload to the API.
    ///   - completionHandler: The completion block to handle the service response.
    func submitEntry(score: Int, completionHandler: @escaping (Result<SubmissionResponse, Error>) -> Void) {
        guard let url = URL(string: baseURLString), let body = try? JSONEncoder().encode(LocalLeaderboardEntry(score: score)) else { return }
        
        var submitRequest = URLRequest(url: url)
        submitRequest.httpMethod = URLRequest.HTTPMethod.put.rawValue
        submitRequest.httpBody = body
        URLRequest.request(submitRequest, responseType: SubmissionResponse.self, completionHandler: completionHandler)
    }
}
