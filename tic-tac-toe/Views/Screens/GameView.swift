import SwiftUI

struct GameView: View {
    var infiniteMode: Bool
    @StateObject private var viewModel: GameViewModel
    @EnvironmentObject var settings: SettingsManager
    
    init(infiniteMode: Bool) {
        self.infiniteMode = infiniteMode
        _viewModel = StateObject(wrappedValue: GameViewModel(infiniteMode: infiniteMode, settings: SettingsManager()))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if let winner = viewModel.winner {
                    let winText = "\(viewModel.name(for: winner)) (\(viewModel.symbol(for: winner))) \(NSLocalizedString("wins", comment: "Wins message"))!"
                    let tieText = NSLocalizedString("tie", comment: "Tie message")

                    Text(winner == .tie ? tieText : winText)
                        .font(.largeTitle)
                        .foregroundColor(viewModel.color(for: winner))
                        .padding()
                    Button(NSLocalizedString("restart", comment: "Restart button")) {
                        viewModel.resetGame()
                    }
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, alignment: .center) // Центрируем по ширине
                } else {
                    Text("\(viewModel.name(for: viewModel.currentPlayer)) (\(viewModel.symbol(for: viewModel.currentPlayer))) \(NSLocalizedString("turn", comment: "Turn message"))")
                        .font(.title)
                        .padding()
                    
                    // Вычисляем размеры ячеек
                    let gridSize = viewModel.board.count
                    let cellSize = min(geometry.size.width, geometry.size.height) / CGFloat(gridSize) - 20
                    
                    // Расчет шрифта и размера ячеек для iPad
                    let isIPad = UIDevice.current.userInterfaceIdiom == .pad
                    let fontSize: CGFloat = isIPad ? 100 : 50 // Увеличиваем размер шрифта для iPad
                    
                    VStack(spacing: 10) {
                        ForEach(0..<gridSize, id: \.self) { row in
                            HStack(spacing: 10) {
                                ForEach(0..<gridSize, id: \.self) { col in
                                    Button(action: {
                                        viewModel.makeMove(row: row, col: col)
                                    }) {
                                        Text(viewModel.symbol(for: viewModel.board[row][col].player))
                                            .font(.system(size: fontSize)) // Используем увеличенный размер шрифта
                                            .frame(width: cellSize, height: cellSize)
                                            .background(Color(UIColor.systemGray5))
                                            .cornerRadius(10)
                                            .foregroundColor(viewModel.board[row][col].player.map { viewModel.color(for: $0) } ?? .gray)
                                    }
                                    .disabled(viewModel.board[row][col].player != nil || viewModel.winner != nil)
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center) // Центрируем по ширине
                }
            }
            .frame(maxWidth: .infinity, alignment: .center) // Центрируем по ширине
            .background(Color(UIColor.systemBackground))
        }
        .frame(maxWidth: .infinity, alignment: .center) // Центрируем по ширине
    }
}

#Preview {
    GameView(infiniteMode: false)
}
