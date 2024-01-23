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
    // TODO: containerize
    private static let cornerRadius: CGFloat = 4
    private static let spawnScaleAnimationDuration: Double = 0.2
    private static let postSpawnScale: Double = 1
    @State var spawnScale: Double = 0.95
    
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
            RoundedRectangle(cornerRadius: Self.cornerRadius).fill(color)
            Text(viewModel.description)
                .foregroundColor(Color.black).font(.title)
        }.applyConditionalModifier(viewModel.isSpawned) { view in
            view
            .scaleEffect(spawnScale)
            .animation(.snappy(duration: Self.spawnScaleAnimationDuration))
            .onAppear {
                spawnScale = Self.postSpawnScale
            }
        }
    }
}
