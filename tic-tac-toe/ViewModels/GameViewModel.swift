import SwiftUI

class GameViewModel: ObservableObject {
    @Published var board: [[Cell]] = []
    @Published var currentPlayer: Player = .x
    @Published var winner: Player? = nil
    
    private let infiniteMode: Bool
    private let settings: SettingsManager
    private var playerMoves: [Player: [(Int, Int)]] = [Player.x: [], Player.o: []]
    
    init(infiniteMode: Bool, settings: SettingsManager) {
        self.infiniteMode = infiniteMode
        self.settings = settings
        resetGame()
    }
    
    func resetGame() {
        let size = settings.boardSize
        board = Array(repeating: Array(repeating: Cell(), count: size), count: size)
        currentPlayer = .x
        winner = nil
        playerMoves = [Player.x: [], Player.o: []]
    }
    
    func makeMove(row: Int, col: Int) {
        guard board[row][col].player == nil else { return }
        
        // Добавляем ход
        board[row][col].player = currentPlayer
        playerMoves[currentPlayer]?.append((row, col))
        
        // Если ходов больше 3, удаляем самый старый
        if self.infiniteMode && playerMoves[currentPlayer]!.count > 3 {
            let (oldRow, oldCol) = playerMoves[currentPlayer]!.removeFirst()
            board[oldRow][oldCol].player = nil
        }
        
        // Проверяем победу
        if checkWinner() {
            winner = currentPlayer
        } else if !self.infiniteMode && isBoardFull() {
            winner = Player.tie
        } else {
            // Смена игрока
            currentPlayer = currentPlayer == Player.x ? Player.o : Player.x
        }
    }
    
    // TODO: rewrite
    private func checkWinner() -> Bool {
        let size = settings.boardSize
        for i in 0..<size {
            if board[i][0].player == currentPlayer && board[i][1].player == currentPlayer && board[i][2].player == currentPlayer {
                return true
            }
            if board[0][i].player == currentPlayer && board[1][i].player == currentPlayer && board[2][i].player == currentPlayer {
                return true
            }
        }
        if board[0][0].player == currentPlayer && board[1][1].player == currentPlayer && board[2][2].player == currentPlayer {
            return true
        }
        if board[0][2].player == currentPlayer && board[1][1].player == currentPlayer && board[2][0].player == currentPlayer {
            return true
        }
        return false
    }
    
    private func isBoardFull() -> Bool {
        return !board.flatMap { $0 }.contains { $0.player == nil }
    }
    
    func symbol(for player: Player?) -> String {
        switch player {
        case .x: return settings.playerXSymbol
        case .o: return settings.playerOSymbol
        case .tie : return ""
        case nil : return ""
        }
    }
    
    func color(for player: Player) -> Color {
        switch player {
        case .x: return settings.playerXColor
        case .o: return settings.playerOColor
        case .tie: return Color.black
        }
    }
    
    func name(for player: Player) -> String {
        switch player {
        case .x: return settings.playerXName
        case .o: return settings.playerOName
        case .tie: return NSLocalizedString("tie_name", comment: "Tie Name")
        }
    }
}
