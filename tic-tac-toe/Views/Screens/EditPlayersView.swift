
import SwiftUI

struct EditPlayersView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var playerSettings: [PlayerSettings] // Массив настроек игроков
    
    var onSave: ([PlayerSettings]) -> Void
    
    @State private var showValidationError = false
    @State private var validationErrorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(playerSettings.indices, id: \.self) { index in
                    Section(header: Text(playerSettings[index].title)) {
                        HStack {
                            Text("name".localized(comment: "Name"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            TextField("player_name".localized(comment: "Name"), text: $playerSettings[index].name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        HStack {
                            Text("symbol".localized(comment: "Symbol"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextField("symbol".localized(comment: "Symbol"), text: $playerSettings[index].symbol)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onChange(of: playerSettings[index].symbol) {
                                    if playerSettings[index].symbol.count > 1 {
                                        playerSettings[index].symbol = String(playerSettings[index].symbol.prefix(1))
                                    }
                                }
                        }
                        
                        ColorPicker("color".localized(comment: "Color"), selection: $playerSettings[index].color)
                    }
                }
            }
            .navigationTitle("edit_players".localized(comment: "Edit Players"))
            .navigationBarItems(
                leading: Button("cancel".localized(comment: "Cancel")) {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("save".localized(comment: "Save")) {
                    if validate() {
                        onSave(playerSettings)
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showValidationError = true
                    }
                }
            )
            .alert(isPresented: $showValidationError) {
                Alert(
                    title: Text("validation_error".localized(comment: "Validation Error")),
                    message: Text(validationErrorMessage),
                    dismissButton: .default(Text("ok".localized(comment: "OK")))
                )
            }
        }
    }
    
    private func validate() -> Bool {
        let symbols = playerSettings.map { $0.symbol }
        if Set(symbols).count != symbols.count {
            validationErrorMessage = "symbols_must_be_different".localized(comment: "Symbols must be different")
            return false
        }
        
        let colors = playerSettings.map { $0.color }
        if Set(colors).count != colors.count {
            validationErrorMessage = "colors_must_be_different".localized(comment: "Colors must be different")
            return false
        }
        
        return true
    }
}

#Preview {
    let settings = SettingsManager()
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
        onSave: { _ in }
    )
}
