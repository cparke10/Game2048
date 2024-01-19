//
//  BoardModel.swift
//  2048_Dev
//
//  Created by user923968 on 7/14/20.
//  Copyright © 2020 user923968. All rights reserved.
//

import Foundation

struct BoardModel {
    var dimension = 4
    var tiles : [[Tile]]
    
    init() {
        let range = 0..<dimension
        tiles = range.map { _ in
            range.map { _ in Tile() }
        }
        
        spawnTile()
        spawnTile()
    }
    
    /// Increments a random 0-valued tile. If none exist, this has no effect.
    mutating private func spawnTile() {
        let emptyTiles = tiles.flattend.filter { $0.value == 0 }
        
        if let targetTile = emptyTiles.randomElement() {
            for (rowIdx, row) in tiles.enumerated() {
                if let targetIdx = row.firstIndex(where: { $0.id == targetTile.id }) {
                    tiles[rowIdx][targetIdx].value = 1
                }
            }
        }
        
    }
    
    /// Performs an array collapse on a single array of tiles.
    /// - Parameters:
    ///   - tiles: The tile array to collapse.
    ///   - isLeft: Describes whether or not the tiles should be collapsed towards the 0 index or towards the end index.
    /// - Returns: The collapsed tile array.
    mutating private func collapseArr(_ tiles: [Tile], isLeft: Bool) -> [Tile] {
        var result: [Tile] = []
        var strippedTiles = tiles.filter { $0.value != 0 } // reduce input array to non-zero values
        
        // for right collapses, reverse strippedArr to enforce right merging behavior in below loop
        strippedTiles = isLeft ? strippedTiles : strippedTiles.reversed()
        
        var shouldSkipPair = false // control flow Bool for below loop
        for (idx, currTile) in strippedTiles.enumerated() {
            // currTile was merged the previous iteration; skip this iteration
            if shouldSkipPair {
                shouldSkipPair = false
                continue
            }
            
            // if the current element is the last element of the stripped row or
            // is not match with the next tile
            if idx == strippedTiles.count-1 || currTile.value != strippedTiles[idx+1].value {
                result.append(currTile)
            } else { // tiles are matched
                let newTile = Tile(id: currTile.id, value: currTile.value + 1)
                result.append(newTile)
                shouldSkipPair = true
            }
        }
        
        // construct pad array
        var zeroPad: [Tile] = []
        for _ in 0..<(dimension-result.count) {
            zeroPad.append(Tile())
        }
        
        // pad and return the result
        // for right swipes, pad the result on the left and undo the pre-merge reverse from above
        return isLeft ? result + zeroPad : zeroPad + result.reversed()
    }
    
    /// Performs a collapse on the array, combining all equal-valued tiles according to the collpase direction.
    /// - Parameter direction: The direction in which the board should be collapsed.
    mutating func collapse(_ direction: CollapseDirection) {
        let isCollapseVertical =  direction.axis == .vertical
        let temporaryBoard = isCollapseVertical ? tiles.transposed : tiles
        let shouldMergeLeft = direction == .left || direction == .up
        
        var newBoard: [[Tile]] = []
        for row in temporaryBoard { newBoard.append(collapseArr(row, isLeft: shouldMergeLeft)) }

        // if the collapse modified the values of the board, proceed to next game state (collapsed board + new tile)
        if (tiles.flattend.map { $0.value } != newBoard.flattend.map { $0.value }) {
            // undo transpose, if performed above
            if isCollapseVertical { newBoard = newBoard.transposed }

            tiles = newBoard // update board
            spawnTile()
        }
    }
    
    /// Represents a tile element in the board.
    struct Tile: Identifiable, CustomStringConvertible {
        var id = UUID()
        var value = 0
        
        /// The string representation of the tile using its value raised to a power of 2.
        public var description : String {
            let displayVal = value == 0 ? "" : (1 << value).description
            return displayVal
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

fileprivate extension Array where Element == [BoardModel.Tile] {
    /// Returns the transposed matrix.
    var transposed: [[BoardModel.Tile]] {
        (0..<count).map { rowIndex in
            (0..<count).map { columnIndex in
                self[columnIndex][rowIndex]
            }
        }
    }
    
    /// Returns an array of all joined subarrays.
    var flattend: [BoardModel.Tile] { reduce([], +) }
}
