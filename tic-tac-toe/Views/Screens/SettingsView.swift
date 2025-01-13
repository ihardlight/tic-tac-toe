import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsManager
    @ObservedObject var languageManager = LanguageManager.shared
    @State private var isEditingPlayers = false
    @State private var showResetAlert = false
    
    private func resetSettings() {
        settings.resetToDefault()
    }
    
    var body: some View {
        Form {
            Section(header: Text("settings_section_header_app".localized())) {
                Picker("language".localized(comment: ""), selection: $languageManager.currentLanguage) {
                    ForEach(languageManager.availableLanguages, id: \.self) { language in
                        Text(language.localized()).tag(language)
                    }
                }
            }
            Section(header: Text("board_settings".localized(comment: "Board settings"))) {
                Picker("board_size".localized(comment: "Board Size"), selection: $settings.boardSize) {
                    Text("3 x 3").tag(3)
                    Text("4 x 4").tag(4)
                    Text("5 x 5").tag(5)
                }
                .pickerStyle(SegmentedPickerStyle())
                .disabled(true)

                Toggle(isOn: $settings.timerEnabled) {
                    Text("timer".localized())
                }
                if settings.timerEnabled {
                    VStack(alignment: .leading) {
                        Text("timer_duration: \(Int(settings.timerDuration)) seconds".localized())
                            .font(.subheadline)
                        Slider(
                            value: $settings.timerDuration,
                            in: 10...120, // Диапазон времени (10-120 секунд)
                            step: 5, // Шаг изменения
                            minimumValueLabel: Text("10s".localized()),
                            maximumValueLabel: Text("120s".localized())
                        ) {
                            Text("Timer Duration")
                        }
                    }
                }
            }
            Section(header: HStack {
                Text("player_settings".localized(comment: "Player settings"))
                Spacer()
                Button(action: {
                    isEditingPlayers = true
                }) {
                    Text("edit".localized(comment: "Edit"))
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }) {
                HStack {
                    Text("player_x_title".localized(comment: "Player X"))
                    Spacer()
                    Text(settings.playerXName)
                    Text(settings.playerXSymbol)
                        .foregroundColor(settings.playerXColor)
                }
                
                HStack {
                    Text("player_o_title".localized(comment: "Player O"))
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
                    Text("reset_settings".localized(comment: "Reset to Default"))
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("settings".localized(comment: "Settings title"))
        .alert(isPresented: $showResetAlert) {
            Alert(
                title: Text("reset_settings_title".localized(comment: "Reset Settings")),
                message: Text("reset_settings_message".localized(comment: "Are you sure you want to reset all settings to default values?")),
                primaryButton: .destructive(Text("reset".localized(comment: "Reset"))) {
                    resetSettings()
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $isEditingPlayers) {
            EditPlayersView(
                playerSettings: [
                    PlayerSettings(
                        title: "player_x".localized(comment: "Player X"),
                        name: settings.playerXName,
                        symbol: settings.playerXSymbol,
                        color: settings.playerXColor
                    ),
                     PlayerSettings(
                        title: "player_o".localized(comment: "Player O"),
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
