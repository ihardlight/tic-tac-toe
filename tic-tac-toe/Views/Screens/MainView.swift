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
            Text(NSLocalizedString("welcome", comment: "Welcome message"))
                .font(.largeTitle)
                .padding()

            NavigationLink(destination: GameView(infiniteMode: false)) {
                Text(NSLocalizedString("game_classic_mode", comment: "Classic game mode"))
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }

            NavigationLink(destination: GameView(infiniteMode: true)) {
                Text(NSLocalizedString("game_infinity_mode", comment: "Game mode without ties"))
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
