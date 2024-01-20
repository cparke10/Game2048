//
//  TileViewModel.swift
//  Game2048
//
//  Created by user253524 on 1/19/24.
//

import Foundation

struct TileViewModel: Identifiable, Hashable {
    let value: Int
    let id = UUID()
    
    init(_ value: Int) {
        self.value = value
    }
}

extension TileViewModel: CustomStringConvertible {
    /// The string representation of the tile using its value raised to a power of 2.
    public var description : String {
        let displayVal = value == 0 ? "" : (1 << value).description
        return displayVal
    }
}
