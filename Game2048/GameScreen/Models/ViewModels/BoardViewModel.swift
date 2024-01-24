//
//  BoardViewModel.swift
//  2048_Dev
//
//  Created by Charlie Parker on 7/15/20.
//  Copyright © 2020 Charlie Parker. All rights reserved.
//

import Foundation

/// The view model for the board. Holds the board and tracks the game over alert boolean to use in the SwiftUI `alert` API.
class BoardViewModel: ObservableObject {
    @Published private var model: BoardModel
    @Published var isPresentingGameOverAlert = false
    var score = 0
    
    init(_ model: BoardModel = BoardModel()) {
        self.model = model
        self.score = model.score
    }
    
    /// The tile view models in the board model.
    var tileViewModels: [[TileViewModel]] {
        return model.tiles.map { row in row.map { TileViewModel(value: $0.value, isSpawned: model.spawnedTile === $0) } }
    }

    /// Performs the collapse on the board model.
    func collapse(direction: BoardModel.CollapseDirection) {
        model.collapse(direction)
        score = model.score
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) { [weak self] in
            self?.isPresentingGameOverAlert = self?.model.isCollapsible == false
        }
    }
    
    func reset() {
        model.reset()
        score = model.score
    }
}
