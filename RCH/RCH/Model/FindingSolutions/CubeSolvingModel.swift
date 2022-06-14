//
//  RubiksCubeSolution.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/8/22.
//

import Foundation

private let debug = true

///        0    1   2
///        3    4   5
///        6    7   8
/// 9 10 11    12 13 14    15 16 17    18 19 20
///21 22 23    24 25 26    27 28 29    30 31 32
///33 34 35    36 37 38    39 40 41    42 43 44
///        45 46 47
///        48 49 50
///        51 52 53

//for turning functions
private let uPositions = [9,10,11,12,13,14,15,16,17,18,19,20]
private let rPositions = [2,5,8,14,26,38,47,50,53,42,30,18]
private let lPositions = [0,3,6,12,24,36,45,48,51,44,32,20]
private let mPositions = [1,4,7,13,25,37,46,49,52,43,31,19]
private let bPositions = [17,29,41,53,52,51,33,21,9,0,1,2]
private let fPositions = [6,7,8,15,27,39,47,46,45,35,23,11]
private let dPositions = [33,34,35,36,37,38,39,40,41,42,43,44]
//for other funcs
private let edgePieces = [1,3,5,7,10,21,23,34,13,24,26,37,16,27,29,40,19,30,32,43,46,48,50,52]
private let cornerPieces = [0,2,6,8,9,11,33,35,12,14,36,38,15,17,39,40,18,20,42,44,45,47,51,53]
private let fixCornerPieces = [9,11,12,14,15,16,17,18,20]

class SolveModel {
    @Published var cube = Dictionary<Int, (Int,String)>()
    var id = 0
    
    private func getPrintColor(pos: Int) -> String {
        return cube[pos]!.1
    }
    
    func printCube() {
        if cube.isNotEmpty {
//            print("White\n", cube[0]!, cube[1]!, cube[2]!,"\n", cube[3]!, cube[4]!, cube[5]!, "\n", cube[6]!, cube[7]!, cube[8]!)
//            print("Orange\n", cube[9]!, cube[10]!, cube[11]!,"\n", cube[21]!, cube[22]!, cube[23]!, "\n", cube[33]!, cube[34]!, cube[35]!)
//            print("Green\n", cube[12]!, cube[13]!, cube[14]!,"\n", cube[24]!, cube[25]!, cube[26]!, "\n", cube[36]!, cube[37]!, cube[38]!)
//            print("Red\n", cube[15]!, cube[16]!, cube[17]!,"\n", cube[27]!, cube[28]!, cube[29]!, "\n", cube[29]!, cube[40]!, cube[41]!)
//            print("Blue\n", cube[18]!, cube[19]!, cube[20]!,"\n", cube[30]!, cube[31]!, cube[32]!, "\n", cube[42]!, cube[43]!, cube[44]!)
//            print("Yellow\n", cube[45]!, cube[46]!, cube[47]!,"\n", cube[48]!, cube[49]!, cube[50]!, "\n", cube[51]!, cube[52]!, cube[53]!)
            
            print("\t",getPrintColor(pos: 0),getPrintColor(pos: 1),getPrintColor(pos: 2),"\n\t", getPrintColor(pos: 3),getPrintColor(pos: 4) ,getPrintColor(pos: 5) , "\n\t",getPrintColor(pos: 6),getPrintColor(pos: 7) , getPrintColor(pos: 8),"\n",getPrintColor(pos: 9), getPrintColor(pos: 10) , getPrintColor(pos: 11) ," ",getPrintColor(pos: 12),getPrintColor(pos: 13) ,getPrintColor(pos: 14) ," ",getPrintColor(pos: 15), getPrintColor(pos: 16), getPrintColor(pos: 17) , " ", getPrintColor(pos: 18) , getPrintColor(pos: 19) , getPrintColor(pos: 20),"\n", getPrintColor(pos: 21), getPrintColor(pos: 22) , getPrintColor(pos: 23), " ", getPrintColor(pos: 24) , getPrintColor(pos: 25) , getPrintColor(pos: 26) , " ", getPrintColor(pos: 27), getPrintColor(pos: 28), getPrintColor(pos: 29), " ", getPrintColor(pos: 30),getPrintColor(pos: 31) , getPrintColor(pos: 32),"\n", getPrintColor(pos: 33), getPrintColor(pos: 34), getPrintColor(pos: 35), " ",getPrintColor(pos: 36),getPrintColor(pos: 37) ,getPrintColor(pos: 38) , " ",getPrintColor(pos: 39), getPrintColor(pos: 40),getPrintColor(pos: 41) , " ",getPrintColor(pos: 42), getPrintColor(pos: 43), getPrintColor(pos: 44),"\n\t",getPrintColor(pos: 45), getPrintColor(pos: 46), getPrintColor(pos: 47),"\n\t",getPrintColor(pos: 48) , getPrintColor(pos: 49) , getPrintColor(pos: 50), "\n\t",getPrintColor(pos: 51) ,getPrintColor(pos: 52) ,getPrintColor(pos: 53) )
        } else {
            print("EMPTY CUBE")
        }
    }
    
    //Take the inputed/scanned arrays and turn into one massive array
    //start with white
    func createModel() {
        //TODO: replace test gettter with actual getter
        modelMapper(start: 0, rowChange: 0, side: 5)
        let colors = [1,2,3,4]
        var start = 9
        for color in colors {
            modelMapper(start: start, rowChange: 9, side: color)
            start += 3
        }
        modelMapper(start: 45, rowChange: 0, side: 6)
    }
    
    ///Start is the starting number
    ///rowChange is the amount each row changes - 3 (so for white 0 because it goes from 0 -> 3 and the normal change is 3, 3-3 =0)
    ///side -> side 1-6 to get colors
    private func modelMapper(start: Int, rowChange: Int, side: Int) {
        let squares = getCubeSideArrayTest(side: side)
        var posChange = 0
        var colorChange = 0
        for i in [0,1,2] {
//            print(id,"ID")
            let s1 = i + colorChange
            let s2 = i + 1 + colorChange
            let s3 = i + 2 + colorChange
//            print("Colors", s1, s2, s3)
            let p1 = i + posChange + start
            let p2 = i + 1 + posChange + start
            let p3 = i + 2 + posChange + start
//            print("Positions",p1,p2,p3)
            cube[p1] = (id, squares[s1])
            cube[p2] = (id + 1, squares[s2])
            cube[p3] = (id + 2, squares[s3])
            colorChange += 2
            posChange += rowChange + 2
            id += 3
        }
    }
    
    //This will resave the new values in the original RubiksCubeModel style
    func deconstructModel() {
        //midSquares are the starting index for the four middle squares
        let midSquares = [9,12,15,18]
        if cube.isNotEmpty {
            if debug {
                for int in [0,1,2,3,4,5,6,7,8] {
                    if let color = cube[int]?.1 {
                        mapColorToSideTest(side: 5, color: color, pos: int + 1)
                    }
                }

                for int in [45,46,47,48,49,50,51,52,53] {
                    if let color = cube[int]?.1 {
                        mapColorToSideTest(side: 6, color: color, pos: int - 44)
                    }
                    
                }
                var side = 1
                for firstIndex in midSquares {
                    var colorAdition = 0
                    var posAdition = 0
                    for int in [0,1,2] {
                        let pos1 = int + posAdition + 1
                        let pos2 = int + posAdition + 2
                        let pos3 = int + posAdition + 3
                        let c1 = (cube[firstIndex + colorAdition]?.1)!
                        let c2 = (cube[firstIndex + colorAdition + 1]?.1)!
                        let c3 = (cube[firstIndex + colorAdition + 2]?.1)!
                        mapColorToSideTest(side: side, color: c1, pos: pos1)
                        mapColorToSideTest(side: side, color: c2, pos: pos2)
                        mapColorToSideTest(side: side, color: c3, pos: pos3)
                        posAdition += 2
                        colorAdition += 12
                    }
                    side += 1
                }
            }
        }
    }
    
    ///This will return the current position, return.0, and also the id of the piece as return.1
    func getYellowEdgePieces() -> [[Int]] {
        var yep: [[Int]] = []
        
        for piece in edgePieces {
            let pInfo = cube[piece]
            if pInfo?.1 == "Y" {
                let tempArr = [piece,pInfo!.0]
                yep.append(tempArr)
            }
        }
        
        return yep
    }
    
    ///This will return  the id of the pieces - note the id's should never change
    func getYellowCornerPieces() -> [Int] {
        var ycp: [Int] = []
        
        for piece in cornerPieces {
            let pInfo = cube[piece]
            if pInfo?.1 == "Y" {
                ycp.append(pInfo!.0)
            }
        }
        return ycp
    }
    
    func getCornerPosition(pieceID: Int) -> Int {
        let cp = getYellowCornerPieces()
        
        for id in cp {
            let pos = getPosFromID(pieceID: id)
            if id == pieceID {
                return pos
            }
        }
        return -1
    }
    
    func getPieceInfo(piece: Int) -> (Int,String){
        if let info = cube[piece] {
            return info
        }
        return (-1,"INVALID")
    }
    
    func getPosFromID(pieceID: Int) -> Int {
        for key in cube.keys {
            let info = cube[key]
            if info?.0 == pieceID {
                return key
            }
        }
        
        return -1
    }
    
    //This will deconstruct a string to apply a set of moves.
    func applyMove(moveString:String) {
        print(moveString)
        let moves = moveString.split(separator: " ")
        
        for move in moves {
            
            let cur = String(move)
            if cur.contains("2") {
                deconstructDoubleMove(move: cur)
            } else if cur.count == 2 {
                deconstructPrimeMove(move: cur)
            } else {
                deconstructMove(move: cur)
            }
//            self.printCube()
        }
    }
    
    ///This will swap all edges on the main face which is turning
    ///e1 - e4 are unimportant so long as they are given in order ( cannot be given randomly)
    ///normal is  clockwise or counter clockwises
    func swapEdges(e1: Int, e2: Int, e3: Int, e4: Int, normal: Bool) {
        let copy = cube[e1]
        if normal {
            //TODO: Check working normal switchEdge
            cube[e1] = cube[e4]
            cube[e4] = cube[e3]
            cube[e3] = cube[e2]
            cube[e2] = copy
        } else {
            //TODO: Check working !normal switchEdge
            cube[e1] = cube[e2]
            cube[e2] = cube[e3]
            cube[e3] = cube[e4]
            cube[e4] = copy
        }
    }
    
    ///Will swap all corners on the main face which is being turned
    ///c1 - c4 should be unimportant as long as in order (try to put c1 as top left, then c4 as buttom left)
    ///normal is clockwise or counter clockwise
    func swapCorners(c1: Int, c2: Int, c3: Int, c4: Int, normal: Bool) {
        let copy = cube[c1]
        if normal {
            //TODO: Check working normal switchCorner
            cube[c1] = cube[c4]
            cube[c4] = cube[c3]
            cube[c3] = cube[c2]
            cube[c2] = copy
        } else {
            //TODO: Check working !normal switchCorner
            cube[c1] = cube[c2]
            cube[c2] = cube[c3]
            cube[c3] = cube[c4]
            cube[c4] = copy
        }
    }
    
    func swapRowCorners(c1: Int, c2: Int, c3: Int, c4: Int, c5: Int, c6: Int, c7: Int, c8: Int, normal: Bool) {
        swapCorners(c1: c1, c2: c2, c3: c3, c4: c4, normal: normal)
        swapCorners(c1: c5, c2: c6, c3: c7, c4: c8, normal: normal)
    }
    
    func swapRows(row: [Int], normal: Bool) {
        //TODO: Ensure that switchRow Corners is using the correct values
        swapRowCorners(c1: row[0], c2: row[3], c3: row[6], c4: row[9], c5: row[2], c6: row[5], c7: row[8], c8: row[11], normal: !normal)
        //TODO: Ensure that is using the correct values are being used for the row edge swap
        swapEdges(e1: row[1], e2: row[4], e3: row[7], e4: row[10], normal: !normal)
    }
    
    func uTurn() {
        //moving the white face with this function ONLY
        //SHOULD ALWAYS HAVE NORMAL BE TRUE
        //c1 = 0: c2 = 2: c3 = 8: c4 = 6
        //e1 = 3: e2 = 1: e3 = 5: e4 = 7
        swapEdges(e1: 3, e2: 1, e3: 5, e4: 7, normal: true)
        swapCorners(c1: 0, c2: 2, c3: 8, c4: 6, normal: true)
        swapRows(row: uPositions, normal: true)
    }
    
    func uPrimeTurn() {
        swapEdges(e1: 3, e2: 1, e3: 5, e4: 7, normal: false)
        swapCorners(c1: 0, c2: 2, c3: 8, c4: 6, normal: false)
        swapRows(row: uPositions, normal: false)
    }
    
    //This will need have true bool values based on how the cube turns
    func rTurn() {
        swapEdges(e1: 27, e2: 16, e3: 29, e4: 40, normal: true)
        swapCorners(c1: 15, c2: 17, c3: 41, c4: 39, normal: true)
        swapRows(row: rPositions, normal: true)
    }
    
    func rPrimeTurn() {
        swapEdges(e1: 27, e2: 16, e3: 29, e4: 40, normal: false)
        swapCorners(c1: 15, c2: 17, c3: 41, c4: 39, normal: false)
        swapRows(row: rPositions, normal: false)
    }
    
    //For l turns the bool are somewhat reversed due to how you hold the cube
    func lTurn() {
        swapEdges(e1: 21, e2: 10, e3: 23, e4: 34, normal: true)
        swapCorners(c1: 9, c2: 11, c3: 35, c4: 33, normal: true)
        swapRows(row: lPositions, normal: false)
    }
    
    func lPrimeTurn() {
        swapEdges(e1: 21, e2: 10, e3: 23, e4: 34, normal: false)
        swapCorners(c1: 9, c2: 11, c3: 35, c4: 33, normal: false)
        swapRows(row: lPositions, normal: true)
    }
    
    func mTurn() {
        swapRows(row: mPositions, normal: false)
    }
    
    func mPrimeTurn() {
        swapRows(row: mPositions, normal: true)
    }
    
    func bTurn() {
        swapEdges(e1: 30, e2: 19, e3: 32, e4: 43, normal: true)
        swapCorners(c1: 18, c2: 20, c3: 44, c4: 42, normal: true)
        swapRows(row: bPositions, normal: true)
    }
    
    func bPrimeTurn() {
        swapEdges(e1: 30, e2: 19, e3: 32, e4: 43, normal: false)
        swapCorners(c1: 18, c2: 20, c3: 44, c4: 42, normal: false)
        swapRows(row: bPositions, normal: false)
    }
    
    func fTurn() {
        swapEdges(e1: 24, e2: 13, e3: 26, e4: 37, normal: true)
        swapCorners(c1: 12, c2: 14, c3: 38, c4: 36, normal: true)
        swapRows(row: fPositions, normal: false)
    }
    
    func fPrimeTurn() {
        swapEdges(e1: 24, e2: 13, e3: 26, e4: 37, normal: false)
        swapCorners(c1: 12, c2: 14, c3: 38, c4: 36, normal: false)
        swapRows(row: fPositions, normal: true)
    }
    
    func dTurn() {
        swapEdges(e1: 48, e2: 46, e3: 50, e4: 52, normal: true)
        swapCorners(c1: 45, c2: 47, c3: 53, c4: 51, normal: true)
        swapRows(row: dPositions, normal: false)
    }
    
    func dPrimeTurn() {
        swapEdges(e1: 48, e2: 46, e3: 50, e4: 52, normal: false)
        swapCorners(c1: 45, c2: 47, c3: 53, c4: 51, normal: false)
        swapRows(row: dPositions, normal: true)
    }
    
    func setScramble() {
        applyMove(moveString: "R U B2 D' L' F2 B R2 B D2 U L2 U' F2 D R B2 U2")
    }
    
    private func deconstructMove(move: String) {
        switch move {
        case "U":
            self.uTurn()
        case "F":
            self.fTurn()
        case "M":
            self.mTurn()
        case "L":
            self.lTurn()
        case "R":
            self.rTurn()
        case "D":
            self.dTurn()
        default:
            self.bTurn()
        }
    }
    
    private func deconstructPrimeMove(move: String) {
        let firstChar = move.first
        switch firstChar {
        case "U":
            self.uPrimeTurn()
        case "F":
            self.fPrimeTurn()
        case "M":
            self.mPrimeTurn()
        case "L":
            self.lPrimeTurn()
        case "R":
            self.rPrimeTurn()
        case "D":
            self.dPrimeTurn()
        default:
            self.bPrimeTurn()
        }
    }
    
    private func deconstructDoubleMove(move: String) {
        switch move {
        case "U2":
            self.uTurn()
            self.uTurn()
        case "F2":
            self.fTurn()
            self.fTurn()
        case "M2":
            self.mTurn()
            self.mTurn()
        case "L2":
            self.lTurn()
            self.lTurn()
        case "R2":
            self.rTurn()
            self.rTurn()
        case "D2":
            self.dTurn()
            self.dTurn()
        default:
            self.bTurn()
            self.bTurn()
        }
    }
}
