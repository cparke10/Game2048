//
//  ContentView.swift
//  Game2048
//
//  Created by user253524 on 1/19/24.
//

import SwiftUI
import SwiftData
import UIKit

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
                            ForEach(0..<viewModel.dimension) { colIdx in
                                TileView(tile: viewModel.tiles[(rowIdx * viewModel.dimension + colIdx)])
                            }
                        }
                        .padding(2)
                    }
                }
                .frame(width: 300, height: 300)
                .padding(8)
                .background(Color.gray.cornerRadius(10))
                .gesture(boardSwipe)
            Spacer()
        }
    }
}

struct TileView: View {
    private let tile: TileViewModel
    private let cornerRadius: CGFloat = 4
    
    /// The color associated with the tile as driven by its value.
    private var color: Color {
        let color: Color
        switch tile.value {
        case 0: color = Color(red: 204/256, green: 192/256, blue: 179.0/256)
        case 1: color = Color(red: 238/256, green: 228/256, blue: 218.0/256)
        case 2: color = Color(red: 237/256, green: 224/256, blue: 200/256)
        case 3: color = Color(red: 242/256, green: 177/256, blue: 121/256)
        case 4: color = Color(red: 245/256, green: 149/256, blue: 99/256)
        case 5: color = Color(red: 246/256, green: 124/256, blue: 95/256)
        case 6: color = Color(red: 246/256, green: 94/256, blue: 59/256)
        case 7: color = Color(red: 237/256, green: 207/256, blue: 114/256)
        case 8: color = Color(red: 237/256, green: 204/256, blue: 97/256)
        case 9: color = Color(red: 237/256, green: 200/256, blue: 80/256)
        case 10: color = Color(red: 237/256, green: 197/256, blue: 63/256)
        case 11: color = Color(red: 237/256, green: 194/256, blue: 46/256)
        default: color = .clear
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
}
