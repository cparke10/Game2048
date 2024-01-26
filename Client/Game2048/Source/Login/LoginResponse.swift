//
//  LoginResponse.swift
//  Game2048
//
//  Created by Charlie Parker on 1/26/24.
//

import Foundation

/// Represents the response from the login API.
struct LoginResponse: Decodable {
    let isSuccessful: Bool
    let data: Data
    
    struct Data: Decodable {
        let id: String
    }
}
