//
//  UserManager.swift
//  Game2048
//
//  Created by Charlie Parker on 1/23/24.
//

import Foundation

struct User: Codable {
    let name: String
    let id: String
}

/// Oversees reading and writing of user data for the application.
class UserManager {
    static let shared = UserManager()
    
    private enum Key: String { case userKey = "UserKey" }
    private static var getUserFromDefaults: User? {
        guard let data = UserDefaults.standard.object(forKey: Key.userKey.rawValue) as? Data else { return nil }
        
        return try? JSONDecoder().decode(User.self, from: data)
    }
    
    private let service = LoginService()
    
    var user: User? {
        willSet {
            guard let encoded = try? JSONEncoder().encode(newValue) else { return }
            
            UserDefaults.standard.setValue(encoded, forKey: Key.userKey.rawValue)
        }
    }
    
    var isLoggedIn: Bool { user != nil }
    
    init() { user = Self.getUserFromDefaults }
    
    /// Attempts to save the user with the username through the login API.
    /// - Parameters:
    ///   - name: the username to save.
    ///   - completionHandler: A hook into the response completion allowing callers to handle call cleanup.
    func saveUser(with name: String, completionHandler: @escaping () -> Void) {
        guard !name.isEmpty else { completionHandler(); return }
        
        service.login(with: name) { [weak self] result in
            defer { completionHandler() }
            guard let self else { return }
            
            switch result {
            case .success(let response):
                guard response.isSuccessful else { return }
                
                user = User(name: name, id: response.data.id)
            case .failure: 
                return
            }
        }
    }
}
