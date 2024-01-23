//
//  TileModel.swift
//  Game2048
//
//  Created by Charlie Parker on 1/22/24.
//

import Foundation

/// Represents a tile element in the board.
class TileModel: Equatable, TileExpressable {
    var value = 0
    
    /// Increase the value of the tile by one.
    func increment(by amount: Int = 1) { value += amount }
    
    static func ==(lhs: TileModel, rhs: TileModel) -> Bool {
        return lhs.value == rhs.value
    }
}

protocol TileExpressable {
    var value: Int { get }
}

extension TileExpressable {
    var expressedValue: Int? {
        return value == 0 ? nil : 1 << value
    }
}
