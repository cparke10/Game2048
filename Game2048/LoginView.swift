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

    var body: some View {
        NavigationStack {
            VStack() {
                Spacer()
                usernameButton
                Spacer()
                submitButton
                    .padding(10)
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                LandingPage()
            }
        }
    }
}

fileprivate extension LoginView {
    var usernameButton: some View {
        TextField("Name", text: $name, prompt: Text("Name").foregroundStyle(.blue))
            .padding()
            .overlay() {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.blue, lineWidth: 2)
            }
            .padding(.horizontal)
    }
    
    var submitButton: some View {
        Button {
            UserManager.shared.saveUser(with: name)
            isLoggedIn = UserManager.shared.isLoggedIn
        } label: {
            Text("Submit")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(colors: [GameColors.color0, GameColors.color11],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
        )
        .cornerRadius(24)
        .padding()
    }
}
