//
//  UserManager.swift
//  Game2048
//
//  Created by user253524 on 1/23/24.
//

import Foundation

struct User: Codable {
    let name: String
}

/// Oversees reading and writing of user data for the application.
class UserManager {
    static let shared = UserManager()
    private static let userKey = "UserKey"
    private static var getUserFromDefaults: User? {
        guard let data = UserDefaults.standard.object(forKey: Self.userKey) as? Data else { return nil }
        
        return try? JSONDecoder().decode(User.self, from: data)
    }
    
    var user: User? {
        willSet {
            guard let encoded = try? JSONEncoder().encode(newValue) else { return }
            
            UserDefaults.standard.setValue(encoded, forKey: Self.userKey)
        }
    }
    var isLoggedIn: Bool { user != nil }
    
    init() { user = Self.getUserFromDefaults }
    
    func saveUser(with name: String) {
        guard !name.isEmpty else { return }
        user = User(name: name)
    }
}
