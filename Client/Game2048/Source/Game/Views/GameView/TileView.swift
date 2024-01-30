//
//  TileView.swift
//  Game2048
//
//  Created by Charlie Parker on 1/22/24.
//

import SwiftUI

/// The view used to represent a tile within the game board.
struct TileView: View {
    private let viewModel: TileViewModel

    /// Container for the constants used in the view
    private struct ViewConstants {
        static let cornerRadius: CGFloat = 4
        static let spawnScaleAnimationDuration: Double = 0.2
        static let preSpawnScale: Double = 0.95
        static let postSpawnScale: Double = 1
    }
    @State private var spawnScale: Double = ViewConstants.preSpawnScale
    
    /// The color associated with the tile as driven by its value.
    private var color: Color {
        let color: Color
        switch viewModel.value {
        case 0: color = GameColors.color0
        case 1: color = GameColors.color1
        case 2: color = GameColors.color2
        case 3: color = GameColors.color3
        case 4: color = GameColors.color4
        case 5: color = GameColors.color5
        case 6: color = GameColors.color6
        case 7: color = GameColors.color7
        case 8: color = GameColors.color8
        case 9: color = GameColors.color9
        case 10: color = GameColors.color10
        case 11: color = GameColors.color11
        default: color = .red
        }
        
        return color
    }
    
    init(viewModel: TileViewModel) { self.viewModel = viewModel }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: ViewConstants.cornerRadius)
                .fill(color)
            Text(viewModel.description)
                .foregroundColor(Color.black).font(.title)
        }.applyConditionalModifier(viewModel.isSpawned) { view in
            view
            .scaleEffect(spawnScale)
            .animation(.snappy(duration: ViewConstants.spawnScaleAnimationDuration))
            .onAppear {
                spawnScale = ViewConstants.postSpawnScale
            }
        }
    }
}
