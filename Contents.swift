import UIKit

enum Player{
    case First
    case Second
}

enum Square{
    case One_One, One_Two, One_Three
    case Two_One, Two_Two, Two_Three
    case Three_One, Three_Two, Three_Three
}

extension Square: RawRepresentable{
    typealias Position = (row:Int, column:Int)
    
    var rawValue: Position{
        switch self{
        case .One_One: return(row:1,column:1)
        case .One_Two: return(row:1,column:2)
        case .One_Three: return(row:1,column:3)

        case .Two_One: return(row:2,column:1)
        case .Two_Two: return(row:2,column:2)
        case .Two_Three: return(row:2,column:3)

        case .Three_One: return(row:3,column:1)
        case .Three_Two: return(row:3,column:2)
        case .Three_Three: return(row:3,column:3)
        }
    }
    
    init?(rawValue: Position){
        switch rawValue {
        case (row:1,column:1): self = .One_One
        case (row:1,column:2): self = .One_Two
        case (row:1,column:3): self = .One_Three

        case (row: 2, column: 1): self = .Two_One
        case (row: 2, column: 2): self = .Two_Two
        case (row: 2, column: 3): self = .Two_Three
            
        case (row: 3, column: 1): self = .Three_One
        case (row: 3, column: 2): self = .Three_Two
        case (row: 3, column: 3): self = .Three_Three
            
        default: return nil
        }
    }
}
    enum GameState{
        case inProgress
        case draw
        case win(Player, WinningStreak)
    }
    enum WinningStreak: String{
        case horizontal
        case vertical
        case diagonal
    }

    extension GameState: CustomStringConvertible{
        var description: String{
            switch self {
            case .inProgress:
                return "Game is running"
            case .draw:
                return "Game ended up in a draw"
            case .win(let player, let streak):
                return "\(player) won on \(streak) combination"
            }
        }
    }

    func result(for sequence: [Square]) -> WinningStreak?{
        guard sequence.count == 3, sequence[0] != sequence [1], sequence[1] != sequence[2], sequence[2] != sequence[0] else { return nil }
        
        if sequence[0].rawValue.row == sequence[1].rawValue.row && sequence[1].rawValue.row == sequence[2].rawValue.row {
            return .horizontal
        }
        if sequence[0].rawValue.column == sequence[1].rawValue.column && sequence[1].rawValue.column == sequence[2].rawValue.column {
            return .vertical
        }
        if (sequence[0].rawValue.row == sequence[0].rawValue.column && sequence[1].rawValue.row == sequence[1].rawValue.column && sequence[2].rawValue.row == sequence[2].rawValue.column) ||
            Set(arrayLiteral: sequence) == Set(arrayLiteral:  [Square.One_Three, .Two_Two, .Three_One]){
            return .diagonal
        }
        return nil
    }

class TicTacToe{
    
    private var sequence = [Square]()
    
    func progress(_ square: Square) -> GameState? {
        guard sequence.count < 9 else { return nil }
        
        sequence.append(square)
        
        guard sequence.count > 4 else { return .inProgress }
        
        var firstPlayerSequence = [Square]()
        var secondPlayerSequence = [Square]()
        
        for (index, square) in sequence.enumerated(){
            index % 2 == 0 ? firstPlayerSequence.append(square) : secondPlayerSequence.append(square)
        }
        
        if let streak = result(for: firstPlayerSequence) {
            return .win(Player.First, streak)
        }else if let streak = result(for: secondPlayerSequence){
            return .win(Player.Second, streak)
        }else{
            return .draw
        }
    }
}

