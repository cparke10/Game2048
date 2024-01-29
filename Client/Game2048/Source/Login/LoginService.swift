//
//  LoginService.swift
//  Game2048
//
//  Created by Charlie Parker on 1/26/24.
//

import Foundation

/// Manges requests to the leaderboard API.
class LoginService {
    
    /// The `Game2048URLRequest` used to make requests to login.
    struct LoginRequest: Game2048URLRequest {
        let pathComponent = "leaderboard"
        let method = HTTPMethod.post
        let body: Data?
    }
    
    /// Performs the request to the login API.
    /// - Parameters:
    ///   - type: The `LeaderboardType` to request the API for.
    ///   - completionHandler: The completion block to handle the service response.
    func login(with username: String, completionHandler: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let body = try? JSONEncoder().encode(["name": username]) else { return }
        
        URLRequest.request(LoginRequest(body: body), responseType: LoginResponse.self, completionHandler: completionHandler)
    }
}
