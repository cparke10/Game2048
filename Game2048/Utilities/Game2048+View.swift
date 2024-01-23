//
//  Game2048+View.swift
//  Game2048
//
//  Created by Charlie Parker on 1/23/24.
//

import SwiftUI

extension View {
    /// Modifies the given view when the condition is true, otherwise returns the view.
    /// - Parameters:
    ///   - condition: The condition to drive the modifer application.
    ///   - transform: The modifier used to transform the view.
    /// - Returns: The modified `View` if the condition is satisifed, otherwise the original `View`.
    @ViewBuilder func applyConditionalModifier<Content: View>(_ condition: Bool, _ transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
