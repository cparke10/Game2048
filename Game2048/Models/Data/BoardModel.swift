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
    var tiles: [[TileModel]]
    var spawnedTile: TileModel?
    var score: Int = 0
    
    /// Describes if the game is over based on available user moves.
    var isCollapsible: Bool { tiles.hasMove }
    
    init() {
        let range = 0..<dimension
        tiles = range.map { _ in
            range.map { _ in TileModel() }
        }
    
        spawnTile()
        spawnTile()
    }
    
    /// Increments a random 0-valued tile. If none exist, this has no effect.
    mutating private func spawnTile() {
        let emptyTiles = tiles.flattened.filter { $0.value == 0 }
        
        let targetTile = emptyTiles.randomElement()
        spawnedTile = targetTile
        targetTile?.increment()
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
                return tile
            } else {
                return tile
            }
        }
        
        // re-add zero padding after filtering them out above
        func createNewTile() -> TileModel { TileModel() }
        let zeroPad = Array(repeating: createNewTile, count: dimension - combinedTiles.count).map { $0() }
        
        // pad and return the result
        // for right swipes, pad the result on the left and undo the pre-merge reverse from above
        return isLeft ? combinedTiles + zeroPad : zeroPad + combinedTiles.reversed()
    }
    
    /// Performs a collapse on the array, combining all equal-valued tiles according to the collpase direction.
    /// - Parameter direction: The direction in which the board should be collapsed.
    mutating func collapse(_ direction: CollapseDirection) {
        guard isCollapsible else { return }
        
        let isCollapseVertical =  direction.axis == .vertical
        let temporaryBoard = isCollapseVertical ? tiles.transposed : tiles
        let shouldMergeLeft = direction == .left || direction == .up
        
        var newBoard: [[TileModel]] = []
        for row in temporaryBoard { newBoard.append(collapseArray(row, isLeft: shouldMergeLeft)) }

        // if the collapse modified the values of the board, proceed to next game state (collapsed board + new tile)
        if tiles != newBoard {
            // undo transpose, if performed above
            if isCollapseVertical { newBoard = newBoard.transposed }

            tiles = newBoard // update board
            spawnTile()
        }
    }

    /// The direction in which the board is collapsed.
    enum CollapseDirection {
        case up, down, left, right
        
        /// The axis of the collapse direction.
        enum Axis { case vertical, horizontal }
        
        /// Returns the axis of the collapse direction.
        var axis: Axis {
            switch self {
            case .up, .down: return .vertical
            case .left, .right: return .horizontal
            }
        }
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
    /// Describes if the matrix has a pair of collapsible tiles on either the horitzontal and vertical axis.
    private var hasPair: Bool {
        func matrixHasPair(_ matrix: [Element]) -> Bool { matrix.map { $0.pairs.contains(true) }.contains(true) }
        
        return matrixHasPair(self) || matrixHasPair(transposed)
    }
    
    /// Describes if the matrix has an available game move, i.e., there is a collapsible pair on either of the axises or there is a 0-valued tile.
    var hasMove: Bool { hasPair || flattened.contains(where: { $0.value == 0 }) }
}
