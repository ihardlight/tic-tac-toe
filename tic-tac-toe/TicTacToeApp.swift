//
//  tic_tac_toeApp.swift
//  tic-tac-toe
//
//  Created by Ilia Mazan on 08.01.2025.
//

import SwiftUI

@main
struct TicTacToeApp: App {
    @StateObject private var settings = SettingsManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
    }
}
