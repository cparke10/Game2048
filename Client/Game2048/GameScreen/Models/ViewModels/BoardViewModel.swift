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
    var score: Int { model.score }
    
    init(_ model: BoardModel = BoardModel()) { self.model = model }
    
    /// The tile view models in the board model.
    var tileViewModels: [[TileViewModel]] {
        model.tiles.map { row in row.map { TileViewModel(id: $0.id, value: $0.value, isSpawned: model.spawnedTile?.id == $0.id) } }
    }

    /// Performs the collapse on the board model.
    func collapse(direction: BoardModel.CollapseDirection) {
        model.collapse(direction)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) { [weak self] in
            self?.isPresentingGameOverAlert = self?.model.isCollapsible == false
        }
    }
    
    func reset() {
        model.reset()
    }
}

// MARK: Accessibility content
extension BoardViewModel {
    var tilesAccessibilityLabel: String {
        tileViewModels.enumerated().map { (rowIndex, row) in
            "Row \(rowIndex + 1): \(row.map { String($0.value) }.joined(separator: ",") )"
        }.joined(separator: ",")
    }
}
