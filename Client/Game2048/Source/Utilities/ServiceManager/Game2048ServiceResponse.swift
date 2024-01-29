//
//  Game2048ServiceResponse.swift
//  Game2048
//
//  Created by Charlie Parker on 1/26/24.
//

import Foundation

/// Protocl used for response objects in service calls.
protocol Game2048ServiceResponse: Decodable {
    associatedtype ModelData: Decodable
    var data: ModelData { get }
}
