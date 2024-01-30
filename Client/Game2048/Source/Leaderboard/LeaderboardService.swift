//
//  LeaderboardService.swift
//  Game2048
//
//  Created by Charlie Parker on 1/23/24.
//

import Foundation

/// Protocol used for requests to the leaderboard API. Allows for inclusion of a userId path component.
fileprivate protocol LeaderboardRequest: Game2048URLRequest {
    var includeUserId: Bool { get }
}

extension LeaderboardRequest {
    /// The portion of the path which describes the userId.
    private var userIdComponent: String { includeUserId ? UserManager.shared.user?.id ?? "" : "" }
    
    var pathComponent: String { "leaderboard/\(userIdComponent)"}
}

/// Manges requests to the leaderboard API.
class LeaderboardService {

    /// The `Game2048URLRequest` used to request the leaderboard for some `LeaderboardType`.
    private struct GetLeaderboardRequest: LeaderboardRequest {
        let includeUserId: Bool
        let method = HTTPMethod.get
        let body: Data? = nil
    }
    
    /// The `Game2048URLRequest` used to submit entries to the leaderboard for the user.
    private struct SubmitLeaderboardEntryRequest: LeaderboardRequest {
        let includeUserId = true
        let method = HTTPMethod.put
        let body: Data?
    }
    
    /// Performs the leaderboard API request for the list of entries.
    /// - Parameters:
    ///   - type: The `LeaderboardType` to request the API for.
    ///   - completionHandler: The completion block to handle the service response.
    func requestLeaderboard(for type: LeaderboardType, completionHandler: @escaping (Result<LeaderboardResponse, Error>) -> Void) {
        URLRequest.request(GetLeaderboardRequest(includeUserId: type == .me),
                           responseType: LeaderboardResponse.self,
                           completionHandler: completionHandler)
    }
    
    /// Performs the leaderboard API request to submit an entry for the user with the game score.
    /// - Parameters:
    ///   - score: The game score to upload to the API.
    ///   - completionHandler: The completion block to handle the service response.
    func submitEntry(score: Int, completionHandler: @escaping (Result<SubmissionResponse, Error>) -> Void) {
        guard let body = try? JSONEncoder().encode(LocalLeaderboardEntry(score: score)) else { return }
        
        URLRequest.request(SubmitLeaderboardEntryRequest(body: body), responseType: SubmissionResponse.self, completionHandler: completionHandler)
    }
}
