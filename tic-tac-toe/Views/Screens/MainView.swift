//
//  MainView.swift
//  tic-tac-toe
//
//  Created by Ilia Mazan on 08.01.2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Text("welcome".localized(comment: "Welcome message"))
                .font(.largeTitle)
                .padding()

            NavigationLink(destination: GameView(infiniteMode: false)) {
                Text("game_classic_mode".localized(comment: "Classic game mode"))
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }

            NavigationLink(destination: GameView(infiniteMode: true)) {
                Text("game_infinity_mode".localized(comment: "Game mode without ties"))
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
        }
    }
}

#Preview {
    MainView()
}
