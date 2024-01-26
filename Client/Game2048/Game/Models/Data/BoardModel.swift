//
//  BoardModel.swift
//  2048_Dev
//
//  Created by Charlie Parker on 7/14/20.
//  Copyright © 2020 Charlie Parker. All rights reserved.
//

import Foundation

/// The model for the board. Manages the game engine of the application.
struct BoardModel {
    var dimension = 4
    var tiles: [[TileModel]] = []
    var spawnedTile: TileModel?
    var score = 0
    
    /// Describes if the game is over based on available user moves.
    var isCollapsible: Bool { tiles.hasMove }
    
    init() { generateInitialBoard(dimension) }
    
    private mutating func generateInitialBoard(_ dimension: Int) {
        let range = 0..<dimension
        self.tiles = range.map { _ in
            range.map { _ in TileModel() }
        }
        
        spawnTile()
        spawnTile()
        spawnedTile = nil // suppress updating of spawnedTile for initial game state

        score = 0
    }
    
    /// Increments a random 0-valued tile. If none exist, this has no effect.
    mutating private func spawnTile() {
        let emptyTiles = tiles.flattened.filter { $0.value == 0 }
        
        let targetTile = emptyTiles.randomElement()
        let amount: Int = ((1...8).randomElement()! % 8) == 0 ? 2 : 1 // increment by 1 or 2 with low probability
        targetTile?.increment(by: amount)
        spawnedTile = targetTile
    }
    
    // MARK: Collapse methods
    
    /// The direction in which the board is collapsed.
    enum CollapseDirection {
        case up, down, left, right
        
        /// Describes if the collapse is relative to the vertical axis.
        var isCollapseAxisVertical: Bool {
            switch self {
            case .up, .down: return true
            case .left, .right: return false
            }
        }
        
        /// Describes if the collapse is occuring to the left.
        var isCollapsingLeft: Bool {
            switch self {
            case .left, .up: return true
            case .right, .down: return false
            }
        }
    }
    
    /// Performs an array collapse on a single array of tiles.
    /// - Parameters:
    ///   - tiles: The tile array to collapse.
    ///   - isLeft: Describes whether or not the tiles should be collapsed towards the 0 index or towards the end index.
    /// - Returns: The collapsed tile array.
    mutating private func collapseArray(_ tiles: [TileModel], isLeft: Bool) -> [TileModel] {
        // for right collapses, reverse the stripped array to enforce right merging behavior in below pairing check
        let strippedTiles = isLeft ? tiles.stripped : tiles.stripped.reversed()
        guard !strippedTiles.isEmpty else { return tiles }
        
        // merge tiles
        let pairedTiles = strippedTiles.pairs
        var shouldSkipPair = false
        let combinedTiles: [TileModel] = strippedTiles.enumerated().compactMap { (index, tile) in
            guard !shouldSkipPair else { shouldSkipPair = false; return nil }
            
            // if the tile is paired with its successor and a pair exists (false in cases: a. array of size one, or b. final tile case), 
            // then increment its value
            if pairedTiles.indices.contains(index), pairedTiles[index] {
                shouldSkipPair = true // ensure next pair is not processed because the nextTile will already be merged
                tile.increment()
                score += tile.expressedValue!
                return tile
            } else {
                return tile
            }
        }
        
        func createNewTile() -> TileModel { TileModel() }
        let zeroPad = Array(repeating: createNewTile, count: dimension - combinedTiles.count).map { $0() }
        
        // append the zero padding and undo the reversal if needed
        return isLeft ? combinedTiles + zeroPad : zeroPad + combinedTiles.reversed()
    }
    
    /// Performs a collapse on the tile matrix, combining all equal-valued tiles according to the collapse direction.
    /// - Parameter direction: The direction in which the board should be collapsed.
    mutating func collapse(_ direction: CollapseDirection) {
        guard isCollapsible else { return }
        
        let shouldMergeLeft = direction.isCollapsingLeft
        let isCollapseVertical =  direction.isCollapseAxisVertical
        let temporaryBoard = isCollapseVertical ? tiles.transposed : tiles
        var newBoard = temporaryBoard.map { collapseArray($0, isLeft: shouldMergeLeft) }
        
        // undo transpose if performed above
        if isCollapseVertical { newBoard = newBoard.transposed }
        
        // if the collapse modified the values of the board, proceed to next game state (collapsed board + new tile)
        if tiles != newBoard {
            tiles = newBoard
            spawnTile()
        } else {
            spawnedTile = nil
        }
    }
    
    // MARK: Reset method
    
    /// Sets the game state to the initial state.
    mutating func reset() {
        generateInitialBoard(dimension)
    }
}

fileprivate extension Array where Element == TileModel {
    /// Returns an array of tiles without 0-valued tiles.
    var stripped: [Element] { filter { $0.value > 0 } }
    
    /// Returns an array of booleans representing the tile relationships.
    var pairs: [Bool] {
        let stripped = stripped
        guard !stripped.isEmpty else { return [] }
        
        return zip(stripped, stripped.suffix(stripped.count - 1)).map { $0.0 == $0.1 }
    }
}

fileprivate extension Array where Element == [TileModel] {
    // MARK: General helper methods
    /// Returns the transposed matrix.
    var transposed: [Element] {
        (0..<count).map { rowIndex in
            (0..<count).map { columnIndex in
                self[columnIndex][rowIndex]
            }
        }
    }
    
    /// Returns an array of all joined subarrays. Useful for simplifying basic checks against the tile values in the matrix.
    var flattened: [TileModel] { reduce([], +) }
    
    // MARK: Game flow helper methods
    /// Describes if the matrix has a pair of collapsible tiles on either the horizontal or vertical axises.
    private var hasPair: Bool {
        func matrixHasPair(_ matrix: [Element]) -> Bool {
            matrix.map { $0.pairs.contains(true) }
                .contains(true)
        }
        
        return matrixHasPair(self) || matrixHasPair(transposed)
    }
    
    /// Describes if the matrix has an available game move, i.e., there is a collapsible pair on either of the axises or there is a 0-valued tile.
    var hasMove: Bool { hasPair || flattened.contains(where: { $0.value == 0 }) }
}
