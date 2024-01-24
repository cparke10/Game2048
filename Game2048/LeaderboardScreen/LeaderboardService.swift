//
//  LeaderboardService.swift
//  Game2048
//
//  Created by Charlie Parker on 1/23/24.
//

import Foundation

class LeaderboardService {
    private let url = URL(string : "https://www.google.com")!
    
    func request(with type: LeaderboardType, completionHandler: @escaping (Result<[LeaderboardEntry], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error {
                completionHandler(.failure(error))
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) { //,
                      // let decoded = try? JSONDecoder().decode(LeaderboardData.self, from: data) {
                completionHandler(.success(Array(repeating: .init(username: "Charlie Parker", score: (0...100000).randomElement()!, date: "11/27/1996"), count: 3) + [.init(username: "Charlie Parker", score: 5, date: "11/27/1996")]))
            } else {
                completionHandler(.failure(URLError(.unknown)))
            }
        }.resume()
    }
}
