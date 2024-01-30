//
//  ServiceManager.swift
//  Game2048
//
//  Created by Charlie Parker on 1/29/24.
//

import Foundation

/// Manager used to build API requests based on app environment.
class ServiceManager {
    static let shared = ServiceManager()
    
    /// The config used for the app service calls. Holds the domain.
    private struct ServiceConfiguration: Decodable {
        let debugDomain: String
        let productionDomain: String
    }
    
    /// Helper function used to parse the config from the plist.
    private static func parseConfigurationPropertyList() -> ServiceConfiguration {
        let url = URL(string: Bundle.main.path(forResource: String(reflecting: ServiceConfiguration.self), ofType: "plist")!)!
        let data = try! Data(contentsOf: url)
        return try! PropertyListDecoder().decode(ServiceConfiguration.self, from: data)
    }
    
    private let configuration: ServiceConfiguration = ServiceManager.parseConfigurationPropertyList()
    
    /// The URL string for the API domain based on app environment.
    var domainString: String {
        #if DEBUG
        return configuration.debugDomain
        #else
        return configuration.productionDomain
        #endif
    }
}
