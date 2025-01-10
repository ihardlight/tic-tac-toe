
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
                            Text(NSLocalizedString("name", comment: "Name"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            TextField(NSLocalizedString("player_name", comment: "Name"), text: $playerSettings[index].name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        HStack {
                            Text(NSLocalizedString("symbol", comment: "Symbol"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextField(NSLocalizedString("symbol", comment: "Symbol"), text: $playerSettings[index].symbol)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onChange(of: playerSettings[index].symbol) {
                                    if playerSettings[index].symbol.count > 1 {
                                        playerSettings[index].symbol = String(playerSettings[index].symbol.prefix(1))
                                    }
                                }
                        }
                        
                        ColorPicker(NSLocalizedString("color", comment: "Color"), selection: $playerSettings[index].color)
                    }
                }
            }
            .navigationTitle(NSLocalizedString("edit_players", comment: "Edit Players"))
            .navigationBarItems(
                leading: Button(NSLocalizedString("cancel", comment: "Cancel")) {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button(NSLocalizedString("save", comment: "Save")) {
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
                    title: Text(NSLocalizedString("validation_error", comment: "Validation Error")),
                    message: Text(validationErrorMessage),
                    dismissButton: .default(Text(NSLocalizedString("ok", comment: "OK")))
                )
            }
        }
    }
    
    private func validate() -> Bool {
        let symbols = playerSettings.map { $0.symbol }
        if Set(symbols).count != symbols.count {
            validationErrorMessage = NSLocalizedString("symbols_must_be_different", comment: "Symbols must be different")
            return false
        }
        
        let colors = playerSettings.map { $0.color }
        if Set(colors).count != colors.count {
            validationErrorMessage = NSLocalizedString("colors_must_be_different", comment: "Colors must be different")
            return false
        }
        
        return true
    }
}

#Preview {
    var settings = SettingsManager()
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
        onSave: { _ in }
    )
}
