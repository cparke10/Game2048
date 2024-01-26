//
//  LoginResponse.swift
//  Game2048
//
//  Created by Charlie Parker on 1/26/24.
//

import Foundation

/// Represents the response from the login API.
struct LoginResponse: Game2048ServiceResponse {
    let isSuccessful: Bool
    let data: ModelData
    
    struct ModelData: Decodable {
        let id: String
    }
}
