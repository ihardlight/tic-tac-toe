import SwiftUI

var BLUE_COLOR_HEX: String = Color.blue.toHex() ?? "0000FF"
var RED_COLOR_HEX: String = Color.red.toHex() ?? "FF0000"

class SettingsManager: ObservableObject {
    // размер доски
    @AppStorage("boardSize") var boardSize: Int = 3

    // Имена игроков
    @AppStorage("playerXName") var playerXName: String = NSLocalizedString("player_x", comment: "Default Player X Name")
    @AppStorage("playerOName") var playerOName: String = NSLocalizedString("player_o", comment: "Default Player O Name")

    // Символы игроков
    @AppStorage("playerXSymbol") var playerXSymbol: String = "X"
    @AppStorage("playerOSymbol") var playerOSymbol: String = "O"

    // Цвета игроков
    @AppStorage("playerXColorHex") private var playerXColorHex: String = BLUE_COLOR_HEX
    @AppStorage("playerOColorHex") private var playerOColorHex: String = RED_COLOR_HEX

    var playerXColor: Color {
        get { Color(hex: playerXColorHex) ?? .blue }
        set { playerXColorHex = newValue.toHex() ?? BLUE_COLOR_HEX }
    }

    var playerOColor: Color {
        get { Color(hex: playerOColorHex) ?? .red }
        set { playerOColorHex = newValue.toHex() ?? RED_COLOR_HEX }
    }

    func resetToDefault() {
        boardSize = 3
        playerXName = NSLocalizedString("player_x", comment: "Default Player X Name")
        playerOName = NSLocalizedString("player_o", comment: "Default Player O Name")
        playerXSymbol = "X"
        playerOSymbol = "O"
        playerXColorHex = BLUE_COLOR_HEX
        playerOColorHex = RED_COLOR_HEX
    }
}
