//
//  TileView.swift
//  Game2048
//
//  Created by user253524 on 1/22/24.
//

import SwiftUI

/// The view used to represent a tile within the game board.
struct TileView: View {
    private let viewModel: TileViewModel
    private let cornerRadius: CGFloat = 4
    @State var spawnScale: Double = 0.95
    
    /// The color associated with the tile as driven by its value.
    private var color: Color {
        let color: Color
        switch viewModel.value {
        case 0: color = Color(red: 204/255, green: 192/255, blue: 179/255)
        case 1: color = Color(red: 238/255, green: 228/255, blue: 218/255)
        case 2: color = Color(red: 237/255, green: 224/255, blue: 200/255)
        case 3: color = Color(red: 242/255, green: 177/255, blue: 121/255)
        case 4: color = Color(red: 245/255, green: 149/255, blue: 99/255)
        case 5: color = Color(red: 246/255, green: 124/255, blue: 95/255)
        case 6: color = Color(red: 246/255, green: 94/255, blue: 59/255)
        case 7: color = Color(red: 237/255, green: 207/255, blue: 114/255)
        case 8: color = Color(red: 237/255, green: 204/255, blue: 97/255)
        case 9: color = Color(red: 237/255, green: 200/255, blue: 80/255)
        case 10: color = Color(red: 237/255, green: 197/255, blue: 63/255)
        case 11: color = Color(red: 237/255, green: 194/255, blue: 46/255)
        default: color = .red
        }
        
        return color
    }
    
    init(viewModel: TileViewModel) { self.viewModel = viewModel }
    
    var body: some View {
        if viewModel.isSpawned {
            baseBody
                .scaleEffect(spawnScale)
                .animation(.snappy(duration: 0.2))
                .onAppear {
                    spawnScale = 1
                }
     
        } else {
            baseBody
        }
    }
    
    private var baseBody: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius).fill(color)
            Text(viewModel.description)
                .foregroundColor(Color.black).font(.title)
        }
    }
}

