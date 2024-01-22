//
//  BoardViewModel.swift
//  2048_Dev
//
//  Created by Charlie Parker on 7/15/20.
//  Copyright © 2020 Charlie Parker. All rights reserved.
//

import Foundation

/// The view model for the board. Holds the board and tracks the game overt alert boolean to use in the SwiftUI `alert` API.
class BoardViewModel: ObservableObject {
    @Published private var model = BoardModel()
    @Published var isPresentingGameOverAlert = false
    
    /// The tile view models in the board model.
    var tileViewModels: [[TileViewModel]] {
        return model.tiles.map { row in row.map { TileViewModel($0.value) } }
    }

    /// Performs the collapse on the board model.
    func collapse(direction: BoardModel.CollapseDirection) {
        model.collapse(direction)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(750)) { [weak self] in
            self?.isPresentingGameOverAlert = self?.model.isGameOver == true
        }
    }
}
