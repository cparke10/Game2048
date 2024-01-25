//
//  TileViewModel.swift
//  Game2048
//
//  Created by Charlie Parker on 1/19/24.
//

import Foundation

/// View model used for the tile. Holds the value, id, and a `Bool` representing if the tile is newly-spawned.
struct TileViewModel: Identifiable, Hashable, TileExpressable {
    let id = UUID()
    let value: Int
    let isSpawned: Bool
}

extension TileViewModel: CustomStringConvertible {
    /// The string representation of the tile using its value raised to a power of 2.
    public var description: String { expressedValue?.description ?? "" }
}
