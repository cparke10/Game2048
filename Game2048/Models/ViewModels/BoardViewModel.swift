//
//  BoardViewModel.swift
//  2048_Dev
//
//  Created by user923968 on 7/15/20.
//  Copyright © 2020 user923968. All rights reserved.
//

import Foundation

class BoardViewModel: ObservableObject {
    @Published private var model = BoardModel()
    var isSwiping = false
    
    var tiles: [[TileViewModel]] {
        return model.tiles.map { row in row.map { TileViewModel($0.value) } }
    }
    
    func collapse(direction: BoardModel.CollapseDirection) {
        model.collapse(direction)
    }
}
