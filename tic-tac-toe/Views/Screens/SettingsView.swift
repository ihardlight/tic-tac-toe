import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsManager
    @State private var isEditingPlayers = false
    @State private var showResetAlert = false
    
    private func resetSettings() {
        settings.resetToDefault()
    }
    
    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("board_settings", comment: "Board settings"))) {
                Picker(NSLocalizedString("board_size", comment: "Board Size"), selection: $settings.boardSize) {
                    Text("3 x 3").tag(3)
                    Text("4 x 4").tag(4)
                    Text("5 x 5").tag(5)
                }
                .pickerStyle(SegmentedPickerStyle())
                .disabled(true)
            }
            Section(header: HStack {
                Text(NSLocalizedString("player_settings", comment: "Player settings"))
                Spacer()
                Button(action: {
                    isEditingPlayers = true
                }) {
                    Text(NSLocalizedString("edit", comment: "Edit"))
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }) {
                HStack {
                    Text(NSLocalizedString("player_x_title", comment: "Player X"))
                    Spacer()
                    Text(settings.playerXName)
                    Text(settings.playerXSymbol)
                        .foregroundColor(settings.playerXColor)
                }
                
                HStack {
                    Text(NSLocalizedString("player_o_title", comment: "Player O"))
                    Spacer()
                    Text(settings.playerOName)
                    Text(settings.playerOSymbol)
                        .foregroundColor(settings.playerOColor)
                }
            }
            
            Section {
                Button(action: {
                    showResetAlert = true
                }) {
                    Text(NSLocalizedString("reset_settings", comment: "Reset to Default"))
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle(NSLocalizedString("settings", comment: "Settings title"))
        .alert(isPresented: $showResetAlert) {
            Alert(
                title: Text(NSLocalizedString("reset_settings_title", comment: "Reset Settings")),
                message: Text(NSLocalizedString("reset_settings_message", comment: "Are you sure you want to reset all settings to default values?")),
                primaryButton: .destructive(Text(NSLocalizedString("reset", comment: "Reset"))) {
                    resetSettings()
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $isEditingPlayers) {
            EditPlayersView(
                playerSettings: [
                    PlayerSettings(
                        title: NSLocalizedString("player_x", comment: "Player X"),
                        name: settings.playerXName,
                        symbol: settings.playerXSymbol,
                        color: settings.playerXColor
                    ),
                     PlayerSettings(
                        title: NSLocalizedString("player_o", comment: "Player O"),
                        name: settings.playerOName,
                        symbol: settings.playerOSymbol,
                        color: settings.playerOColor
                     )
                ],
                onSave: { updatedPlayers in
                    settings.playerXName = updatedPlayers[0].name
                    settings.playerXSymbol = updatedPlayers[0].symbol
                    settings.playerXColor = updatedPlayers[0].color
                    settings.playerOName = updatedPlayers[1].name
                    settings.playerOSymbol = updatedPlayers[1].symbol
                    settings.playerOColor = updatedPlayers[1].color
                }
            )
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsManager())
}
