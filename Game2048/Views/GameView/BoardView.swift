//
//  BoardView.swift
//  Game2048
//
//  Created by user253524 on 1/19/24.
//

import SwiftUI

/// The view used to represent the game board.
struct BoardView: View {
    @ObservedObject var viewModel: BoardViewModel = .init()
    
    /// Container for the constants used in the view
    private struct ViewConstants {
        static let rowPadding: CGFloat = 2
        static let boardSize: CGFloat = 300
        static let boardPadding: CGFloat = 10
        static let boardCornerRadius: CGFloat = 10
    }   
    
    /// The gesture which handles swipe actions on the board by updating the view model.
    private var boardSwipe: some Gesture {
        DragGesture()
            .onEnded {
                let xDelta = $0.location.x - $0.startLocation.x
                let yDelta = $0.location.y - $0.startLocation.y
                
                let currSwipe: BoardModel.CollapseDirection
                if abs(xDelta) > abs(yDelta) {
                    currSwipe = xDelta < 0 ? .left : .right
                } else {
                    currSwipe = yDelta < 0 ? .up : .down
                }
                
                viewModel.collapse(direction: currSwipe)
            }
    }
    
    var body: some View {
        VStack {
            ForEach(0..<4) { rowIdx in
                HStack {
                    ForEach(0..<4) { colIdx in
                        TileView(tile: viewModel.tiles[(rowIdx * 4 + colIdx)])
                    }
                }
                .padding(ViewConstants.rowPadding)
            }
        }
        .frame(width: ViewConstants.boardSize, height: ViewConstants.boardSize)
        .padding(ViewConstants.boardPadding)
        .background(Color.gray.cornerRadius(ViewConstants.boardCornerRadius))
        .gesture(boardSwipe)
    }
    
    /// The view used to represent a tile within the game board.
    private struct TileView: View {
        private let tile: TileViewModel
        private let cornerRadius: CGFloat = 4
        
        /// The color associated with the tile as driven by its value.
        private var color: Color {
            let color: Color
            switch tile.value {
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
        
        init(tile: TileViewModel) { self.tile = tile }
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius).fill(color)
                Text(tile.description)
                    .foregroundColor(Color.black).font(.title)
            }
        }
    }}