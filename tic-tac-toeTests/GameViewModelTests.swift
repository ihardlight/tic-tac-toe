import XCTest
@testable import tic_tac_toe

class GameViewModelTests: XCTestCase {
    
    var settings = SettingsManager()
    var viewModel: GameViewModel!

    override func setUp() {
        super.setUp()
        viewModel = GameViewModel(infiniteMode: true, settings: settings)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // Тест: Начальное состояние игры
    func testInitialState() {
        XCTAssertEqual(viewModel.currentPlayer, Player.x)
        XCTAssertNil(viewModel.winner)
        XCTAssertTrue(viewModel.board.allSatisfy { $0.allSatisfy { $0.player == nil } })
    }
    
    // Тест: Смена игрока после хода
    func testPlayerSwitching() {
        viewModel.makeMove(row: 0, col: 0)
        XCTAssertEqual(viewModel.currentPlayer, Player.o)
        
        viewModel.makeMove(row: 1, col: 1)
        XCTAssertEqual(viewModel.currentPlayer, Player.x)
    }
    
    // Тест: Игрок не может ходить в занятую клетку
    func testInvalidMove() {
        viewModel.makeMove(row: 0, col: 0)
        viewModel.makeMove(row: 0, col: 0) // Пытаемся повторно сделать ход в ту же клетку
        XCTAssertEqual(viewModel.board[0][0].player, Player.x)
        XCTAssertEqual(viewModel.currentPlayer, Player.o)
    }
    
    // Тест: Победа игрока
    func testPlayerWins() {
        viewModel.makeMove(row: 0, col: 0)
        viewModel.makeMove(row: 1, col: 0)
        viewModel.makeMove(row: 0, col: 1)
        viewModel.makeMove(row: 1, col: 1)
        viewModel.makeMove(row: 0, col: 2) // X должен победить
        XCTAssertEqual(viewModel.winner, Player.x)
    }
    
    // Тест: Ограничение на три хода
    func testMoveLimit() {
        viewModel.makeMove(row: 0, col: 0) // X
        viewModel.makeMove(row: 1, col: 0) // O
        viewModel.makeMove(row: 0, col: 1) // X
        viewModel.makeMove(row: 1, col: 1) // O
        viewModel.makeMove(row: 0, col: 2) // X
        viewModel.makeMove(row: 1, col: 2) // O
        viewModel.makeMove(row: 2, col: 2) // X (удаляем первый ход X)

        // Проверяем, что удалён старый ход
        XCTAssertEqual(viewModel.board[0][0].player, nil)
        XCTAssertEqual(viewModel.board[0][1].player, Player.x)
        XCTAssertEqual(viewModel.board[0][2].player, Player.x)
    }
    
    // Тест: Игра продолжается после удаления старых ходов
    func testGameContinuesAfterRemovingOldMoves() {
        viewModel.makeMove(row: 0, col: 0) // X
        viewModel.makeMove(row: 1, col: 0) // O
        viewModel.makeMove(row: 0, col: 1) // X
        viewModel.makeMove(row: 1, col: 1) // O
        viewModel.makeMove(row: 1, col: 2) // X
        viewModel.makeMove(row: 2, col: 2) // O
        viewModel.makeMove(row: 2, col: 0) // X (удаляется первый ход X)
        
        // Проверяем, что первый ход X удалён
        XCTAssertEqual(viewModel.board[0][0].player, nil)
        
        // Проверяем, что остальные ходы X сохранились
        XCTAssertEqual(viewModel.board[0][1].player, Player.x)
        XCTAssertEqual(viewModel.board[1][2].player, Player.x)
        XCTAssertEqual(viewModel.board[2][0].player, Player.x)
        
        // Проверяем, что первый ход O удалён
        viewModel.makeMove(row: 2, col: 1) // O (удаляется первый ход O)
        XCTAssertEqual(viewModel.board[1][0].player, nil)
        
        // Проверяем, что игра продолжается
        XCTAssertNil(viewModel.winner)
        XCTAssertEqual(viewModel.currentPlayer, Player.x)
    }
    
    // Тест: Сброс игры
    func testGameReset() {
        viewModel.makeMove(row: 0, col: 0) // X
        viewModel.makeMove(row: 1, col: 1) // O
        viewModel.resetGame()
        
        XCTAssertNil(viewModel.winner)
        XCTAssertEqual(viewModel.currentPlayer, Player.x)
        XCTAssertTrue(viewModel.board.allSatisfy { $0.allSatisfy { $0.player == nil } })
    }

    // Тест: Победа на диагонали
    func testDiagonalWin() {
        viewModel.makeMove(row: 0, col: 0) // X
        viewModel.makeMove(row: 0, col: 1) // O
        viewModel.makeMove(row: 1, col: 1) // X
        viewModel.makeMove(row: 0, col: 2) // O
        viewModel.makeMove(row: 2, col: 2) // X
        XCTAssertEqual(viewModel.winner, Player.x)
    }
    
    // Тест: Победа на обратной диагонали
    func testReverseDiagonalWin() {
        viewModel.makeMove(row: 0, col: 2) // X
        viewModel.makeMove(row: 0, col: 0) // O
        viewModel.makeMove(row: 1, col: 1) // X
        viewModel.makeMove(row: 1, col: 0) // O
        viewModel.makeMove(row: 2, col: 0) // X
        XCTAssertEqual(viewModel.winner, Player.x)
    }

    // Тест: Победа по вертикали
    func testVerticalWin() {
        viewModel.makeMove(row: 0, col: 0) // X
        viewModel.makeMove(row: 0, col: 1) // O
        viewModel.makeMove(row: 1, col: 0) // X
        viewModel.makeMove(row: 1, col: 1) // O
        viewModel.makeMove(row: 2, col: 0) // X
        XCTAssertEqual(viewModel.winner, Player.x)
    }
}
