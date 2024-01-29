//
//  Game2048URLRequest.swift
//  Game2048
//
//  Created by Charlie Parker on 1/29/24.
//

import Foundation

/// The protocol to manage the `URLRequest`s in the app used to make service calls to the game APIs.
protocol Game2048URLRequest {
    var pathComponent: String { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
}

extension Game2048URLRequest {
    private var domainString: String { ServiceManager.shared.domainString }
    private var urlString: String { "\(domainString)/\(pathComponent)" }
    
    /// The `URLRequest` built using the path component.
    var request: URLRequest {
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        return request
    }
}

/// Container for the supported HTTP methods.
enum HTTPMethod: String {
    case get
    case post
    case put
    
    var rawValue: String { String(describing: self).uppercased() }
}
