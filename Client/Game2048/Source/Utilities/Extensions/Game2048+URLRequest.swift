//
//  Game2048+URLRequest.swift
//  Game2048
//
//  Created by Charlie Parker on 1/26/24.
//

import Foundation

extension URLRequest {
    /// Helper function to manage response handling for requests to game APIs.
    /// - Parameters:
    ///   - urlRequest: The `URLRequest` to start the task for.
    ///   - responseType: The response type associated with the request.
    ///   - completionHandler: The completion block to handle the service response.
    static func request<ResponseType: Decodable>(_ gameRequest: Game2048URLRequest,
                                                 responseType: ResponseType.Type,
                                                 completionHandler: @escaping (Result<ResponseType, Error>) -> Void) {
        URLSession.shared.dataTask(with: gameRequest.request) { (data, response, error) in
            if let error {
                completionHandler(.failure(error))
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode),
                      let decoded = try? JSONDecoder().decode(ResponseType.self, from: data) {
                completionHandler(.success(decoded))
            } else {
                completionHandler(.failure(URLError(.unknown)))
            }
        }.resume()
    }
}
