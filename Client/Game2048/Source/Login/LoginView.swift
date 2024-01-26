//
//  LoginView.swift
//  Game2048
//
//  Created by Charlie Parker on 1/24/24.
//

import SwiftUI

/// The view used for the login page on app launch, allowing the user to specifcy a name to associate with their game session.
/// - Note: If the user is already logged in, the `LandingPage` is pushed onto the stack immediately.
struct LoginView: View {
    @State private var name: String = ""
    @State private var isLoggedIn = UserManager.shared.isLoggedIn
    
    private struct ViewConstants {
        static let submitButtonPadding: CGFloat = 10
        static let submitButtonCornerRadius: CGFloat = 24
        static let submitButtonHeight: CGFloat = 48
        static let submitButtonTitleContent = NSLocalizedString("Submit", comment: "Login view submit button title content")
        static let usernameOverlayCornerRadius: CGFloat = 12
        static let usernameOverlayLineWidth: CGFloat = 2
        static let usernamePlaceholderContent = NSLocalizedString("Name", comment: "Login view name field placeholder content")
    }

    var body: some View {
        NavigationStack {
            VStack() {
                Spacer()
                usernameButton
                Spacer()
                submitButton
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                LandingPage()
            }
        }
    }
}

fileprivate extension LoginView {
    var usernameButton: some View {
        TextField(ViewConstants.usernamePlaceholderContent,
                  text: $name,
                  prompt: Text(ViewConstants.usernamePlaceholderContent)
            .foregroundStyle(.blue))
            .padding()
            .overlay() {
                RoundedRectangle(cornerRadius: ViewConstants.usernameOverlayCornerRadius)
                    .stroke(.blue, lineWidth: ViewConstants.usernameOverlayLineWidth)
            }
            .padding(.horizontal)
    }
    
    var submitButton: some View {
        Button {
            UserManager.shared.saveUser(with: name) {
                isLoggedIn = UserManager.shared.isLoggedIn
            }
        } label: {
            Text(ViewConstants.submitButtonTitleContent)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
        }
        .frame(height: ViewConstants.submitButtonHeight)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(colors: [GameColors.color4, GameColors.color11],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
        )
        .cornerRadius(ViewConstants.submitButtonCornerRadius)
        .padding(ViewConstants.submitButtonPadding)
    }
}
