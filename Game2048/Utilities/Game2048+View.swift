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
    
    /// Wrapper around the accessibility modifier APIs which allows for setting of label and hint.
    /// - Parameters:
    ///   - label: The label string to apply to the view.
    ///   - hint: The hint string to apply to the view.
    /// - Returns: The modified view with the accessibility properties applied.
    @ViewBuilder func setAccessibilityAttributes(label: String? = nil, hint: String? = nil) -> some View {
        accessibilityElement()
            .applyConditionalModifier(label != nil) { $0.accessibilityLabel(Text(label!)) }
            .applyConditionalModifier(hint != nil) { $0.accessibilityHint(Text(hint!)) }
    }
}
