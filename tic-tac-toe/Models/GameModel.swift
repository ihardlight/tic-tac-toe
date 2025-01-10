enum Player: String {
    case x = "X"
    case o = "O"
    case tie = "tie"
    
    var next: Player {
        self == .x ? .o : .x
    }
}

struct Cell {
    var player: Player?
}
