//
//  ContentView.swift
//  Game2048
//
//  Created by user253524 on 1/19/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var viewModel: BoardViewModel
    
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
            Spacer().frame(height: 40)
            VStack {
                ForEach(0..<4) { rowIdx in
                    HStack {
                        ForEach(0..<4) { colIdx in
                            TileView(tile: viewModel.tiles[(rowIdx * 4 + colIdx)])
                        }
                    }
                }
            }
            .frame(width: 300, height: 300)
            .background(Color.gray)
            .gesture(boardSwipe)
            Spacer()
            
        }
    }
}

struct TileView: View {
    private let tile: BoardModel.Tile
    private let cornerRadius: CGFloat = 4
    
    init(tile: BoardModel.Tile) { self.tile = tile }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius).fill(Color.orange)
            Text(tile.description)
                .foregroundColor(Color.white).font(.title)
        }
    }
}
