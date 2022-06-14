//
//  BegSolveCross.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/9/22.
//
///        0    1   2
///        3    4   5
///        6    7   8
/// 9 10 11    12 13 14    15 16 17    18 19 20
///21 22 23    24 25 26    27 28 29    30 31 32
///33 34 35    36 37 38    39 40 41    42 43 44
///        45 46 47
///        48 49 50
///        51 52 53

import Foundation

//NOTE: The max amount of moves that should be have in a cross solution is 8 moves for an optimal solution

class BegSolveCross {
    var finished = false
    var moves = ""
    let sm: SolveModel
    var unfinishedPieces = [Int]()
    
    init(sm: SolveModel) {
        //this should be editable because it SHOULDN'T ACT AS A REFERENCE
        self.sm = sm
    }
    
    //Going to solve it piece by piece - ignoring any 'pre-moves' or ways to optimize
    func solveBasicCross() -> String{
        moves = ""
        var pieces = sm.getYellowEdgePieces()
        var finished = isSolved(piecesInfo: pieces)
        for piece in pieces {
            if !solvedPiece(piece: piece[0]) {
                unfinishedPieces.append(piece[0])
            }
        }
//        print(unfinishedPieces)
        while !finished {
//            print(unfinishedPieces)
            let currentPiece = unfinishedPieces[0] // made this random Element because it would get caught in annoying loops where it did nothing - maybe fixed it???
            let other = findAssociatedSide(piece: currentPiece)
            let color = sm.getPieceInfo(piece: other).1
            let sf = onSameFace(color: color, other: other)
            let sameFace = sf.0
            let sfStep = sf.1
            //TODO: REVISIT THIS TO MAKE IT MORE EFFIECENT
            ///steps
            ///1: Re-arange pre-existing peices on the yellow face
            ///2: solve any face matching pieces (any move which is already matching its other color and can be solve in 1 move (R, R' or 2R for ex)
            ///3: Solve all pieces with yellow on the white face - can be solved in two moves and since all other pieces are already in place no worries about fixing them
            ///4: Solve yellow pieces not on the white face (so ones on blue, red, green, and orange faces)
            var move = ""
            if sameFace {
                // so if it is set I do nothing so check that it is not set
                if sfStep != "SET" {
                    move = sfStep
                }
            } else {
                if currentPiece == 1 || currentPiece == 3 || currentPiece == 5 || currentPiece == 7 {
                    move = alignTop(piece: currentPiece)
                } else {
                    //I want to do the simpliest thing in terms of code - this will not be optimal in terms of number of move but will work
                    //get piece to top SAFELY (preserve the cross) then re enter the loop and should solve???!
                    move = moveToTop(piece: currentPiece)
                }
            }
            
            sm.applyMove(moveString: move)
            moves += "\n" + move
            pieces = sm.getYellowEdgePieces()
            sm.printCube()
            //to stop inf loop - unfinPieces must be reset each time since the cube is changing each time
            unfinishedPieces = [Int]()
            for piece in pieces {
                if !solvedPiece(piece: piece[0]) {
                    unfinishedPieces.append(piece[0])
                }
            }
            finished = isSolved(piecesInfo: pieces)
        }
        return moves
    }
    
    private func moveToTop(piece: Int) -> String{
        var move = ""
        
        switch piece {
            //red face
        case 16:
            move += "R' F' U F R"
        case 27:
            move += "F' U F"
        case 29:
            move += "B U B'"
        case 40:
            //orange face
            move += "R F' U F"
        case 23:
            move += "F U F'"
        case 21:
            move += "B' U B"
        case 10:
            move += "L' B' U B L"
        case 34:
            move += "L F' U F "
            //green face
        case 13:
            move += "F R U' R' F'"
        case 24:
            move += "L' U L"
        case 26:
            move += "R U R'"
        case 37:
            move += "F' R U R'"
        //Blue face
        case 19:
            move += "B L U' L' B'"
        case 30:
            move += "R' U R"
        case 32:
            move += "L U' L"
        default:
            //case 43
            move += "B' L U' L'"
        }
        //move??? TODO: CEHC OWKRING
        return move
    }
    
    private func alignTop(piece: Int) -> String {
        var move = ""
        let other = findAssociatedSide(piece: piece)
        let color = sm.getPieceInfo(piece: other).1
        switch color {
        case "R":
            //not 5
            switch piece {
            case 1:
                move += "U"
            case 3:
                move += "U2"
            default:
                move += "U'"
            }
        case "B":
            //not 1
            switch piece {
            case 3:
                move += "U"
            case 7:
                move += "U2"
            default:
                move += "U'"
            }
        case "G":
            //not 7
            switch piece {
            case 5:
                move += "U"
            case 1:
                move += "U2"
            default:
                move += "U'"
            }
        default:
            //not 3
            switch piece {
            case 7:
                move += "U"
            case 5:
                move += "U2"
            default:
                move += "U'"
            }
        }
        move += properSlotForWhiteFace(color: color)
        
        return move
    }
    
    private func properSlotForWhiteFace(color: String) -> String{
        switch color {
        case "R":
            return " R2"
        case "G":
            return " F2"
        case "O":
            return " L2"
        default:
            return " B2"
        }
    }
    
    private func isSolved(piecesInfo: [[Int]]) -> Bool {
        for piece in piecesInfo {
            let finPiece = solvedPiece(piece: piece[0])
            if !finPiece {
                return false
            }
            
        }
        return true
    }
    
    private func solvedPiece(piece: Int) -> Bool {
        let other = findAssociatedSide(piece: piece)
        let color = sm.getPieceInfo(piece: other).1
        switch color {
        case "R":
            if other != 40 {
                return false
            }
        case "O":
            if other != 34 {
                return false
            }
        case "G":
            if other != 37 {
                return false
            }
        default:
            if other != 43 {
                return false
            }
        }
        return true
    }
    
    private func findAssociatedSide(piece: Int) -> Int{
        let epa = EdgePairs()
        let pair = epa.associatePair(piece: piece)
        return pair
    }
    
    //This I thikn is not working because of what I am using the color as. The color is currently the other piece and I do not think that is correct?
    ///Returns a bool and string so that this same function can be reused later when actually solving.
    private func onSameFace(color: String, other: Int) -> (Bool, String){
        switch color{
        case "R":
            let center = 28
            if other == center + 1 {
                return (true, "R")
            } else if other == center - 1 {
                return (true, "R'")
            } else if other == center - 12 {
                return (true, "R2")
            } else if other == center + 12{
                return (true, "SET")
            } else {
                return (false, "NA")
            }
        case "O":
            let center = 22
            if other == center + 1 {
                return (true, "L")
            } else if other == center - 1 {
                return (true, "L'")
            } else if other == center - 12 {
                return (true, "L2")
            } else if other == center + 12{
                return (true, "SET")
            } else {
                return (false, "NA")
            }
        case "B":
            let center = 31
            if other == center + 1 {
                return (true, "B")
            } else if other == center - 1 {
                return (true, "B'")
            } else if other == center - 12 {
                return (true, "B2")
            } else if other == center + 12{
                return (true, "SET")
            } else {
                return (false, "NA")
            }
        default:
            let center = 25
            if other == center + 1 {
                return (true, "F")
            } else if other == center - 1 {
                return (true, "F'")
            } else if other == center - 12 {
                return (true, "F2")
            } else if other == center + 12{
                return (true, "SET")
            } else {
                return (false, "NA")
            }
        }
    }
}
