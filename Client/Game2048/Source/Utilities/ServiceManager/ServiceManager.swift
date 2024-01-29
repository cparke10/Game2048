//
//  ServiceManager.swift
//  Game2048
//
//  Created by Charlie Parker on 1/29/24.
//

import Foundation

/// Manager used to built API requests based on app environment.
class ServiceManager {
    static let shared = ServiceManager()
    
    private struct ServiceConfiguration: Decodable {
        let debugDomain: String
        let productionDomain: String
    }
    
    private static func parseConfigurationPropertyList() -> ServiceConfiguration {
        let url = URL(string: Bundle.main.path(forResource: String(reflecting: ServiceConfiguration.self), ofType: "plist")!)!
        let data = try! Data(contentsOf: url)
        return try! PropertyListDecoder().decode(ServiceConfiguration.self, from: data)
    }
    
    private let configuration: ServiceConfiguration = ServiceManager.parseConfigurationPropertyList()
    
    var domainString: String {
        #if DEBUG
        return configuration.debugDomain
        #else
        return configuration.productionDomain
        #endif
    }
}
