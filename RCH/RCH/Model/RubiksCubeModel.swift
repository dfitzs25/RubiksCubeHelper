//
//  RubiksCubeModel.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/5/22.
//

import Foundation
import SwiftUI

//Int to Color representation
//1 = Orange
//2 = Green
//3 = Red
//4 = Blue
//5 = White
//6 = Yellow


private var orangeSide = ["E","E","E","E","O","E","E","E","E"]
private var greenSide = ["E","E","E","E","G","E","E","E","E"]
private var redSide = ["E","E","E","E","R","E","E","E","E"]
private var blueSide = ["E","E","E","E","B","E","E","E","E"]
private var whiteSide = ["E","E","E","E","W","E","E","E","E"]
private var yellowSide = ["E","E","E","E","Y","E","E","E","E"]

private var orageTest = ["O","G","G","O","O","Y","B","G","R"]
private var greenTest = ["R","B","G","R","G","Y","W","B","R"]
private var redTest = ["W","B","Y","G","R","O","Y","R","Y"]
private var blueTest = ["B","H","B","B","B","Y","H","R","Y"]
private var whiteTest = ["W","O","R","O","W","R","W","W","O"]
private var yellowTest = ["B","Y","G","W","Y","G","O","W","G"]

///side: the center piece color (i.e 1 if orange side)
///color: The color of the piece being mapped (i.e R if red piece)
///pos: 1-8 going from top left to bottom right. Left edge is 4
func mapColorToSide(side: Int, color: String, pos: Int){
    switch side{
    case 1:
        orangeSide[pos - 1] = color
    case 2:
        greenSide[pos - 1] = color
    case 3:
        redSide[pos - 1] = color
    case 4:
        blueSide[pos - 1] = color
    case 5:
        whiteSide[pos - 1] = color
    case 6:
        yellowSide[pos - 1] = color
    default:
        print("Invalid Side was given to the mapColorToSide")
    }
}

func mapColorToSideTest(side: Int, color: String, pos: Int){
    switch side{
    case 1:
        orageTest[pos - 1] = color
    case 2:
        greenTest[pos - 1] = color
    case 3:
        redTest[pos - 1] = color
    case 4:
        blueTest[pos - 1] = color
    case 5:
        whiteTest[pos - 1] = color
    case 6:
        yellowTest[pos - 1] = color
    default:
        print("Invalid Side was given to the mapColorToSide")
    }
}

///This will return a string show the colors of the cube
///will probably be used for printing only 
func formatCubeSide(side: Int) -> String{
    switch side{
    case 1:
        return formatArray(array: orangeSide)
    case 2:
        return formatArray(array: greenSide)
    case 3:
        return formatArray(array: redSide)
    case 4:
        return formatArray(array: blueSide)
    case 5:
        return formatArray(array: whiteSide)
    case 6:
        return formatArray(array: yellowSide)
    default:
        return("Invalid Side was given to the mapColorToSide")
    }
}

func getCubeSideArray(side: Int) -> [String] {
    switch side{
    case 1:
        return orangeSide
    case 2:
        return greenSide
    case 3:
        return redSide
    case 4:
        return blueSide
    case 5:
        return whiteSide
    case 6:
        return yellowSide
    default:
        return(["Invalid Side was given to the mapColorToSide"])
    }
}


func getCubeSideArrayTest(side: Int) -> [String] {
    switch side{
    case 1:
        return orageTest
    case 2:
        return greenTest
    case 3:
        return redTest
    case 4:
        return blueTest
    case 5:
        return whiteTest
    case 6:
        return yellowTest
    default:
        return(["Invalid Side was given to the mapColorToSide"])
    }
}

func formatArray(array: [String]) -> String {
    var format = ""
    let positions = [0,1,2,3,4,5,6,7,8]
    
    for position in positions {
        format += array[position]
        
        if position == 2 || position == 5 {
            format += "\n"
        }
    }
    
    
    return format
}

struct CubeSide: View {
    let positions = [1,2,3,4,5,6,7,8,9]
    var side: [String]
    var width: CGFloat
    var height: CGFloat
    var frameSize: CGFloat = 80
    
    var body: some View {
        ZStack {
            RubkisGrid()
                .stroke(Color.secondary, lineWidth: 2)
                .frame(frameSize)
                .background(.secondary)
                .position(x: width, y: height)
                ForEach(0..<9) { i in
                    RubikSquare(color: side[i], ogX: width, ogY: height, pos: i+1, frameSize: frameSize)
                }
        }
    }
}


struct RubikSquare: View {
    var color: String
    var ogX: CGFloat
    var ogY: CGFloat
    var pos: Int
    var frameSize: CGFloat
    
    func changeXPosition() -> CGFloat{
        if pos == 1  || pos == 7{
//            print("PRINGINT TFOR THE TOUR BOEUH TOUHS BELOW")
            let pos = cornerXPosition(frame: frameSize, mag: 1, offset: CGSize(ogX, ogY), xBool: false)
//            print (pos," X VALUE",frameSize, "frame size ogX and ogY->>>",ogX,ogY)
            return pos - gridWidth/2
        } else if pos == 3 || pos == 9 {
            return cornerXPosition(frame: frameSize, mag: 1, offset: CGSize(ogX, ogY), xBool: true) - gridWidth/2
        } else if pos == 4 {
            return edgeXPosition(frame: frameSize, mag: 1, offset: CGSize(ogX, ogY), xBool: false, xSame: false) - gridWidth/2
        } else if pos == 6 {
            return edgeXPosition(frame: frameSize, mag: 1, offset: CGSize(ogX, ogY), xBool: true, xSame: false) - gridWidth/2
        }
        return ogX
    }
    
    func changeYPosition() -> CGFloat{
        if pos == 1 || pos == 3{
            let pos = cornerYPosition(frame: frameSize, mag: 1, offset: CGSize(ogX,ogY), yBool: false)
//            print(pos, "Y POS",frameSize, "frame size ogX and ogY->>>",ogX,ogY)
            return pos - gridHeight/2
        } else if pos == 7 || pos == 9 {
            return cornerYPosition(frame: frameSize, mag: 1, offset: CGSize(ogX,ogY), yBool: true) - gridHeight/2
        } else if pos == 2 {
            return edgeYPosition(frame: frameSize, mag: 1, offset: CGSize(ogX,ogY), yBool: false, xSame: true) - gridHeight/2
        } else if pos == 8 {
            return edgeYPosition(frame: frameSize, mag: 1, offset: CGSize(ogX,ogY), yBool: true, xSame: true) - gridHeight/2
        }
        return ogY
    }
    
    var body: some View {
        if color != "H" {
            Rectangle()
                .frame(frameSize/3 - 2)
                .foregroundColor(squareColor(color: color))
                .position(x: changeXPosition(), y: changeYPosition())
        } else {
            MissingColor(frame: frameSize/3 - 2)
                .position(x: changeXPosition(), y: changeYPosition())
        }
        
    }
}

struct ModdeledTestCube: View {
    var body: some View {
        VStack{
            SideSelector(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            Spacer()
        }
    }
}

struct ModdeledCube: View {
    
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        ZStack{
            CubeSide(side: getCubeSideArray(side: 5),width: width, height: height)
            CubeSide(side: getCubeSideArray(side: 1),width: width, height: height + 90)
            CubeSide(side: getCubeSideArray(side: 2),width: width + 90, height: height + 90)
            CubeSide(side: getCubeSideArray(side: 3),width: width - 90, height: height + 90)
            CubeSide(side: getCubeSideArray(side: 4),width: width + 180, height: height + 90)
            CubeSide(side: getCubeSideArray(side: 6),width: width, height: height + 180)
        }
    }
}
