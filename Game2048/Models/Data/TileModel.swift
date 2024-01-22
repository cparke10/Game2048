//
//  TileModel.swift
//  Game2048
//
//  Created by Charlie Parker on 1/22/24.
//

import Foundation

/// Represents a tile element in the board.
class TileModel: Equatable {
    var value = 0
    
    /// Increase the value of the tile by one.
    func increment() { value += 1 }
    
    static func ==(lhs: TileModel, rhs: TileModel) -> Bool {
        return lhs.value == rhs.value
    }
}
