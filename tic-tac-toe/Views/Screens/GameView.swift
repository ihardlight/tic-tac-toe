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
            ScrollView {
                VStack {
                    Text(viewModel.title)
                        .font(.largeTitle)
                        .foregroundColor(viewModel.winner != nil ? viewModel.color(for: viewModel.winner!) : .primary)
                        .padding()
                    
                    // Вычисляем размеры ячеек
                    let gridSize = viewModel.board.count
                    let cellSize = min(geometry.size.width, geometry.size.height) / CGFloat(gridSize) - 20
                    
                    // Расчет шрифта и размера ячеек для iPad
                    let isIPad = UIDevice.current.userInterfaceIdiom == .pad
                    let fontSize: CGFloat = isIPad ? 100 : 50 // Увеличиваем размер шрифта для iPad
                    let lineWidth: CGFloat = isIPad ? 10 : 5
                    
                    ZStack {
                        VStack(spacing: 10) {
                            ForEach(0..<gridSize, id: \.self) { row in
                                HStack(spacing: 10) {
                                    ForEach(0..<gridSize, id: \.self) { col in
                                        CellView(
                                            content: viewModel.symbol(for: viewModel.board[row][col].player),
                                            foregroundColor: viewModel.board[row][col].player.map { viewModel.color(for: $0) },
                                            fontSize: fontSize,
                                            cellSize: cellSize,
                                            disabled: viewModel.board[row][col].player != nil || viewModel.winner != nil,
                                            onAction: {
                                                viewModel.makeMove(row: row, col: col)
                                            }
                                        )
                                    }
                                }
                            }
                        }
                        
                        if let start = viewModel.winningLineStart, let end = viewModel.winningLineEnd, let winner = viewModel.winner {
                            WinningLine(gridSize: gridSize, start: start, end: end)
                                .stroke(viewModel.color(for: winner), lineWidth: lineWidth)
                                .animation(.easeInOut, value: winner)
                        }
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Центрируем по ширине
                    
                    if (settings.timerEnabled) {
                        CircularTimerView(timer: viewModel.timer, duration: settings.timerDuration)
                            .font(.system(size: fontSize))
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.5)
                    }
                    
                    Button("restart".localized(comment: "Restart button")) {
                        viewModel.resetGame()
                    }
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, alignment: .center) // Центрируем по ширине
                    .opacity(viewModel.winner != nil ? 1.0 : 0.0)
                }
                .frame(alignment: .center)
                .background(Color(UIColor.systemBackground))
                .onReceive(viewModel.timer.$hasExpired) { expired in
                    if (expired) {
                        viewModel.abortGameTimerExpired()
                    }
                }
            }
        }
        
    }
}

#Preview("Classic mode") {
    GameView(infiniteMode: false)
        .environmentObject(SettingsManager())
}

#Preview("Infinity mode") {
    GameView(infiniteMode: true)
        .environmentObject(SettingsManager())
}
