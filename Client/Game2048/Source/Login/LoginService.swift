//
//  LoginService.swift
//  Game2048
//
//  Created by Charlie Parker on 1/26/24.
//

import Foundation

/// Manges requests to the leaderboard API.
class LoginService {
    private let baseRequest = URLRequest(url: URL(string : "https://www.google.com")!)
    
    /// Performs the request to the login API.
    /// - Parameters:
    ///   - type: The `LeaderboardType` to request the API for.
    ///   - completionHandler: The completion block to handle the service response.
    func login(with username: String, completionHandler: @escaping (Result<LoginResponse, Error>) -> Void) {
        var request = baseRequest
        request.httpMethod = URLRequest.HTTPMethod.post.rawValue
        
        URLRequest.request(baseRequest, responseType: LoginResponse.self, completionHandler: completionHandler)
    }
}
