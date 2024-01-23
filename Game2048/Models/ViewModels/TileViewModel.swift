//
//  TileViewModel.swift
//  Game2048
//
//  Created by Charlie Parker on 1/19/24.
//

import Foundation

struct TileViewModel: Identifiable, Hashable, TileExpressable {
    let id = UUID()
    let value: Int
    let isSpawned: Bool
}

extension TileViewModel: CustomStringConvertible {
    /// The string representation of the tile using its value raised to a power of 2.
    public var description: String { expressedValue?.description ?? "" }
}
