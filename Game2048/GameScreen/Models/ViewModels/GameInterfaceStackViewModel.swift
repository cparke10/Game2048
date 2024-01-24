//
//  GameInterfaceStack.swift
//  Game2048
//
//  Created by Charlie Parker on 1/24/24.
//

import Foundation

struct GameInterfaceStackViewModel {
    let score: Int
    let resetCallback: () -> Void
}

// MARK: Accessibility content
extension GameInterfaceStackViewModel {
    var resetAccessibilityLabel: String { NSLocalizedString("Reset button", comment: "Reset button accessibility label content") }
    var resetAccesibilityHint: String { NSLocalizedString("Reset the game board", comment: "Reset button accessibility label hint") }
}
