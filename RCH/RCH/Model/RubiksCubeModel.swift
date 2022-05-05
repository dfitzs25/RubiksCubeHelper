//
//  RubiksCubeModel.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/5/22.
//

import Foundation

//Int to Color representation
//1 = Orange
//2 = Green
//3 = Red
//4 = Blue
//5 = White
//6 = Yellow


private var orangeSide = [String]()
private var greenSide = [String]()
private var redSide = [String]()
private var blueSide = [String]()
private var whiteSide = [String]()
private var yellowSide = [String]()

///side: the center piece color (i.e 1 if orange side)
///color: The color of the piece being mapped (i.e R if red piece)
///pos: 1-8 going from top left to bottom right. Left edge is 4
func mapColorToSide(side: Int, color: String, pos: Int){
    switch side{
    case 1:
        orangeSide[pos] = color
        orangeSide[5] = "O"
    case 2:
        greenSide[pos] = color
        greenSide[5] = "G"
    case 3:
        redSide[pos] = color
        redSide[5] = "R"
    case 4:
        blueSide[pos] = color
        blueSide[5] = "B"
    case 5:
        whiteSide[pos] = color
        whiteSide[5] = "W"
    case 6:
        yellowSide[pos] = color
        yellowSide[5] = "Y"
    default:
        print("Invalid Side was given to the mapColorToSide")
    }
}

func formatSide(side: Int) -> String{
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

func formatArray(array: [String]) -> String {
    var format = ""
    let positions = [1,2,3,4,5,6,7,8,9]
    
    for position in positions {
        let color = array[position]
        format += color
        if position % 3 == 0 {
            format += "\n"
        }
    }
    
    
    return format
}
