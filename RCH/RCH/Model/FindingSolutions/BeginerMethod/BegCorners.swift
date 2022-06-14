//
//  SimpleF2L.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/11/22.
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
///This returns true if, based on the given colors, the white face needs to be turned twice to have proper alignment
private func doubleUTurnNeeded(sideColor: String, currentSideColor: String) -> Bool {
    //long if statements but is needed
    if sideColor == "R" && currentSideColor == "O" {
        return true
    } else if sideColor == "O" && currentSideColor == "R" {
        return true
    } else if sideColor == "B" && currentSideColor == "G" {
        return true
    } else if sideColor == "G" && currentSideColor == "B" {
        return true
    }
    return false
}

///This will return true if the cube needs a U' turn to be propperly aligned
private func uPrimeTurnNeeded(sideColor: String, currentSideColor: String) -> Bool {
    if sideColor == "R" && currentSideColor == "G" {
        return true
    } else if sideColor == "B" && currentSideColor == "R" {
        return true
    } else if sideColor == "O" && currentSideColor == "B" {
        return true
    } else if sideColor == "G" && currentSideColor == "O" {
        return true
    }
    return false
}

/// Will return true if the cube needs a U turn to be propperly aligned
private func uTurnNeeded(sideColor: String, currentSideColor: String) -> Bool {
    if sideColor == "R" && currentSideColor == "B" {
        return true
    } else if sideColor == "B" && currentSideColor == "O" {
        return true
    } else if sideColor == "O" && currentSideColor == "G" {
        return true
    } else if sideColor == "G" && currentSideColor == "R" {
        return true
    }
    return false
}

//will return either 0 2 6 or 8 based on the colors given (numbers represent ideal side)
private func assessWhiteFacingPosition(colorOne: String, colorTwo: String) -> Int {
    if colorOne == "O" && colorTwo == "G" || colorOne == "G" && colorTwo == "O" {
        return 6
    } else if colorOne == "O" && colorTwo == "B" || colorOne == "B" && colorTwo == "O" {
        return 0
    } else if colorOne == "R" && colorTwo == "G" || colorOne == "G" && colorTwo == "R" {
        return 8
    } else if colorOne == "R" && colorTwo == "B" || colorOne == "B" && colorTwo == "R" {
        return 2
    } else {
        //something is wrong
        return -1
    }
}
//proper piece means aligned above where it should be inserted
//make it so a proper piece can slot in
//have abilitiy to make a piece propper
//have ability to bring a piece up from bottom row
//have ability to lower a piece from the white face
class BegCorners {
    var sm: SolveModel
    var moves = ""
    var unsolvedCorners = [Int]()
    var cp = CornerPairs()
    
    init(sm: SolveModel){
        self.sm = sm
    }
    
    func solveCorners() -> String{
        //reset classwide moves string so it can be used again
        moves = ""
        //make a value for current ID - this will be -1 until the loop
        var currentID = -1
        //fill unsolved corners with IDS of all yellow corners
        unsolvedCorners = sm.getYellowCornerPieces()
        //prune unsolvedCorners to find the solved pieces (done with the allCornersAreSolved function)
        var allCornersSolved = allCornersAreSolved()
        //TODO: Remove this print statement - only for testing purposes
        print(unsolvedCorners)
        //loop while allCornersSolved is not true
        while (!allCornersSolved) {
            //make a new varaible to store the string of this pieces moves
            var currentMoves = ""
            var move = "" // this variable is for making moves 
            //set currentID as unsolvedCorners[0] because that should always be contained in the array if in this loop
            currentID = unsolvedCorners[0]
            //TODO: Relocate this func currently here for testing
            //get piece off of the white face if possible
            move = getYellowPieceOffWhiteFace(id: currentID)
            if move != "INVALID" {
                sm.applyMove(moveString: move) //one white face and needs to be removed
                currentMoves += " " + move
            }
            //move piece out of the bottom row
            move = movePieceOutOfBottomRow(id: currentID)
            if move != "INVALID" {
                sm.applyMove(moveString: move) //in bottom row and needs to be removed 
                currentMoves += " " + move
            }
            //test for proper position
            move = alignCornerPieceAboveProperSpace(id: currentID)
            if move != "PROPPER" {
                sm.applyMove(moveString: move) //not propper piece so must be moved
                currentMoves += " " + move
            }
            //now is in the proper spot and can be solved
            move = slotCornerPieceIntoYellowFace(id: currentID)
            //apply move to the SolveModel
            sm.applyMove(moveString: move)
            //add move to currentMoves
            currentMoves += " " +  move
            //add currentMoves to moves (moves is the class wide string for tracking all moves done)
            moves += currentMoves + "\n" // the new line is for readability TODO: Remove new line if needed
            //re-calculate allCornersSolved so loop can end
            allCornersSolved = allCornersAreSolved()
        }
        
        return moves
    }
    
    ///This will take a yellow corner off of the white face if it is there
    private func getYellowPieceOffWhiteFace(id: Int) -> String {
        var move = ""
        //for this we want the yellow piece to be above the slot it wants to go into
        //first we must make sure it is there, this will result in either a U U' or U2 move
        let yellowPos = sm.getPosFromID(pieceID: id)
        let otherPositions = cp.associatePair(piece: yellowPos)
        //we want both colors to find the ideal spot to preform this set of moves
        let colorOne = sm.getPieceInfo(piece: otherPositions.0).1
        let colorTwo = sm.getPieceInfo(piece: otherPositions.1).1
        //get ideal location from those two colors
        let idealPositoin = assessWhiteFacingPosition(colorOne: colorOne, colorTwo: colorTwo)
        //compare ideal to yellow pos and then move acordingly
        if idealPositoin == 6 && yellowPos == 2 || idealPositoin == 2 && yellowPos == 6 || idealPositoin == 0 && yellowPos == 8 || idealPositoin == 8 && yellowPos == 0 {
            move += "U2 "
        } else if idealPositoin == 6 && yellowPos == 0 || idealPositoin == 8 && yellowPos == 6 || idealPositoin == 2 && yellowPos == 8 || idealPositoin == 0 && yellowPos == 2 {
            move += "U' "
        } else if idealPositoin == 6 && yellowPos == 8 || idealPositoin == 0 && yellowPos == 6 || idealPositoin == 2 && yellowPos == 0 || idealPositoin == 8 && yellowPos == 2 {
            move += "U "
        }
        //now we should make our move based on ideal because yellowPos is still in the wrong spot
        switch idealPositoin {
        case 0:
            move += "L U' L'"
        case 2:
            move += "R' U R"
        case 6:
            move += "L' U L"
        case 8:
            move += "R U' R'"
        default:
            //should now happen so for testing below
            move = "INVALID"
        }
        
        return move
    }
    
    ///This will move a corner piece into the top row so that it can either be aligned propperly or slotted into place
    private func movePieceOutOfBottomRow(id: Int) -> String {
        //we need the yellow pieces position in order to determin if it needs to be moved
        let yellowPos = sm.getPosFromID(pieceID: id)
        //now we just look through all cases and see if it needs to be move
        //NOTE the piece can be facing the yellow face and since we know it is invalid we should remove it as well.
        switch yellowPos {
        case 33:
            return "L U L'"
        case 35:
            return "L' U' L"
        case 36:
            return "L' U L"
        case 38:
            return "R U' R'"
        case 39:
            return "R U R'"
        case 41:
            return "R' U' R"
        case 42:
            return  "R' U R"
        case 44:
            return "L U' L'"
        case 45:
            return "L' U L"
        case 47:
            return "R U' R'"
        case 51:
            return "L U' L'"
        case 53:
            return "R' U R "
        default:
            //no cases apply do nothign
            return "INVALID"
        }
    }
    
    ///This will align a piece above the slot it should be put into
    ///This assumes that the piece is on the correct row and does not need any adjustment
    ///This will move so that the piece given can safely use slotCornerPieceIntoYellowFace
    private func alignCornerPieceAboveProperSpace(id: Int) -> String {
        var move = "" //Stores the move(s) which need to be applied to the solve model
        //for this we need the color of the other two sides because we want to match the side color to the correct face.
        //get positions for the other sides of the yellow corner - use the CornerPair.associatePair(piece: Int) which means we need the pos of the given ID
        let yellowPos = sm.getPosFromID(pieceID: id)
        let otherPositions = cp.associatePair(piece: yellowPos)
        var sidePosition = -1 // This will be assigned later and used to move the corner peice to the proper place
        //We now know each other position - but we only want the position which is NOT on the top face so we quickly find which one we want
        if [0,2,6,8].contains(otherPositions.0) {
            //if othPos.0 is true then we want the second value returned
            sidePosition = otherPositions.1
        } else {
            //we know that the position we are after is .0 because of the prev if statement
            sidePosition = otherPositions.0
        }
        //now we need the color so we can see how much we need to move the top layer if at all.
        let sideColor = sm.getPieceInfo(piece: sidePosition).1 // this function returns two values - the piece id and string (only want the string)
        //we also need the currentSideColor
        var currentSideColor = "" // Empty for now
        if sidePosition == 9 || sidePosition == 11 {
            currentSideColor = "O"
        } else if sidePosition == 12 || sidePosition == 14 {
            currentSideColor = "G"
        } else if sidePosition == 15 || sidePosition == 17 {
            currentSideColor = "R"
        } else if sidePosition == 18 || sidePosition == 20 {
            currentSideColor = "B"
        }
        //after this we can check for how much we need to move it
        if sideColor == currentSideColor {
            move += "PROPPER" // this is to check if move needs to be applied
        } else if doubleUTurnNeeded(sideColor: sideColor, currentSideColor: currentSideColor) {
            move += "U2"
        } else if uPrimeTurnNeeded(sideColor: sideColor, currentSideColor: currentSideColor) {
            move += "U'"
        } else if uTurnNeeded(sideColor: sideColor, currentSideColor: currentSideColor) {
            move += "U"
        }
        //the proper adjustment have been decided now must be returned 
        return move
    }
    
    ///This will put a corner piece into the yellow face - an assumption being made here is that it is in the proper position already.
    ///The piece should be above the slot it wants to be inserted into
    private func slotCornerPieceIntoYellowFace(id: Int) -> String{
        var move = "" // just stores the move string to be applied later
        //get the position of the yellow face (this is the only position that should matter)
        let yellowPos = sm.getPosFromID(pieceID: id)
        //now check the position - can only be in 8 spots as seen below, each would return a different set of moves (String)
        switch yellowPos {
        case 9:
            move += "L U L'"
        case 11:
            move += "L' U' L"
        case 12:
            move += "F U F'"
        case 14:
            move += "F' U' F"
        case 15:
            move += "R U R'"
        case 17:
            move += "R' U' R"
        case 18:
            move += "B U B'"
        case 20:
            move += "B' U' B"
        default:
            move += ""
        }
        
        return move
    }
    
    ///This should only be executed after unsolvedCorners has been filled with values.
    ///This will also prune unsolvedCorners so if the bottom corners are not finished only unsolved cornesr will remain in that array
    private func allCornersAreSolved() -> Bool {
        //get the size of unsolvedCorners for traversing the array. This will be diferent each time hopefully
        let amountUnsolved = unsolvedCorners.count // should not need to alter this because it will be used to check if all pieces are solved
        var solvedIDs = [Int]() // This is used to prune the unsolvedCorners array
        for unknownID in unsolvedCorners {
            if cornerIsSolved(id: unknownID) {
                solvedIDs.append(unknownID)
            } // There is not else statement because I want to find all solved corners and remove them from unsolvedCorners
        }
        //loop through solved position to trim unsolvedCorners
        for solvedID in solvedIDs {
            //find the position of the solvedID
            if let solvedPos = unsolvedCorners.firstIndex(of: solvedID) { // return the position of the solved piece
                //remove the solved piece from the array since this should always be true
                unsolvedCorners.remove(at: solvedPos)
            }
            
        }
        //the only way for this to be true should be if the amount of solvedPositions is equal to amountUnsolved by the end of this. if 1 was left unsolved and the new amount of solvedPositions is 1 then that should mean all pieces are solved
        let amountSolved = solvedIDs.count
        if amountSolved == amountUnsolved {
            return true
        }
        return false
    }
    
    ///This will chekc if a corner piece is solved returns a true value if solved
    private func cornerIsSolved(id: Int) -> Bool {
        //I need to get yellow pos (pos from ID)
        //the two other colors and their position
        let yellowPos = sm.getPosFromID(pieceID: id)
        //first I can check if yellowPos is on the yellow face, if it isnt then cannot be solved
        //this is useful because it allows me to save time by not performing 5 other functions
        if ![45,47,51,53].contains(yellowPos) {
            return false
        }
        //yellowPos is in a valid spot so I need to check that the colors are also valid
        let otherPositions = cp.associatePair(piece: yellowPos)
        let otherPosOne = otherPositions.0
        let otherPosTwo = otherPositions.1
        //get each color of those two other positions
        let otherColOne = sm.getPieceInfo(piece: otherPosOne).1
        let otherColTwo = sm.getPieceInfo(piece: otherPosTwo).1
        //now check based on what ever position the yellowPos is in if the two colors match what they should be
        switch yellowPos {
            //to do this made two bool values and will make sure both are true in the return statement
        case 45:
            let colorOne = otherColOne == "G" || otherColOne == "O"
            let colorTwo = otherColTwo == "G" || otherColTwo == "O"
            return colorOne && colorTwo
        case 47:
            let colorOne = otherColOne == "G" || otherColOne == "R"
            let colorTwo = otherColTwo == "G" || otherColTwo == "R"
            return colorOne && colorTwo
        case 51:
            let colorOne = otherColOne == "B" || otherColOne == "O"
            let colorTwo = otherColTwo == "B" || otherColTwo == "O"
            return colorOne && colorTwo
        default:
            let colorOne = otherColOne == "B" || otherColOne == "R"
            let colorTwo = otherColTwo == "B" || otherColTwo == "R"
            return colorOne && colorTwo
        }
    }
    
    
}
