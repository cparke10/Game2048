//
//  LeaderboardService.swift
//  Game2048
//
//  Created by Charlie Parker on 1/23/24.
//

import Foundation

/// Manges requests to the leaderboard API.
class LeaderboardService {
    private let baseRequest = URLRequest(url: URL(string : "https://www.google.com")!)
    
    /// Performs the leaderboard API request for the list of entries.
    /// - Parameters:
    ///   - type: The `LeaderboardType` to request the API for.
    ///   - completionHandler: The completion block to handle the service response.
    func requestLeaderboard(for type: LeaderboardType, completionHandler: @escaping (Result<[LeaderboardEntry], Error>) -> Void) {
        request(baseRequest, responseType: [LeaderboardEntry].self, completionHandler: completionHandler)
    }
    
    /// Performs the leaderboard API request to submit an entry based on the score.
    /// - Parameters:
    ///   - score: The game score to upload to the API.
    ///   - completionHandler: The completion block to handle the service response.
    func submitEntry(score: Int, completionHandler: @escaping (Result<SubmissionResponse, Error>) -> Void) {
        let entry = LocalLeaderboardEntry(username: UserManager.shared.user!.name, score: score)
        var submitRequest = baseRequest
        submitRequest.httpMethod = "POST"
        
        guard let body = try? JSONEncoder().encode(entry) else { return }
        
        submitRequest.httpBody = body
        request(baseRequest, responseType: SubmissionResponse.self, completionHandler: completionHandler)
    }
    
    /// Helper function to handle requests to the leaderboard API.
    /// - Parameters:
    ///   - urlRequest: The `URLRequest` to start the task for.
    ///   - responseType: The response type associated with the request.
    ///   - completionHandler: The completion block to handle the service response.
    private func request<ResponseType: Decodable>(_ urlRequest: URLRequest,
                                                  responseType: ResponseType.Type,
                                                  completionHandler: @escaping (Result<ResponseType, Error>) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error {
                completionHandler(.failure(error))
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode),
                      let decoded = try? JSONDecoder().decode(ResponseType.self, from: data) {
            } else {
                completionHandler(.failure(URLError(.unknown)))
            }
        }.resume()
    }
}
