//
//  ContentView.swift
//  Game2048
//
//  Created by Charlie Parker on 1/19/24.
//

import SwiftUI

struct LandingPage: View {
    
    static let headerSpacerHeight: CGFloat = 30
    @State private var name: String = ""
    @State private var isLoggedIn = UserManager.shared.isLoggedIn

    var body: some View {
        NavigationStack {
            loginPage
                .navigationDestination(isPresented: $isLoggedIn) {
                    VStack {
                        Spacer().frame(height: Self.headerSpacerHeight)
                        BoardView()
                        Spacer()
                        LeaderboardButton()
                    }
                    .navigationBarBackButtonHidden(true)
                }
        }
    }
}

extension LandingPage {
    var loginPage: some View {
        VStack() {
            Spacer()
            TextField("Name", text: $name, prompt: Text("Name").foregroundStyle(.blue))
                .padding()
                .overlay() {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.blue, lineWidth: 2)
                }
                .padding(.horizontal)
            Spacer()
            submitButton
                .padding(10)
        }
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
        .cornerRadius(20)
        .padding()
    }
}
