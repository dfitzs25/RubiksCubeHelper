//
//  ColorProcessing.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/5/22.
//

import Foundation
import UIKit
import SwiftUI

func idColor(color: UIColor) -> String {
    var red: CGFloat = 0
    var blue: CGFloat = 0
    var green: CGFloat = 0
    var alpha: CGFloat = 0
    //set values above to rgb values of color
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    red = 255 * red
    blue = 255 * blue
    green = 255 * green
//    print("red:",red,"green:",green,"blue:",blue)
    
    if (greenColor(red: red, blue: blue, green: green)){
        return "G"
    } else if (redColor(red: red, blue: blue, green: green) && orangeColor(red: red, blue: blue, green: green)) {
        return redOrangeDecider(red: red, blue: blue, green: green)
    } else if (blueColor(red: red, blue: blue, green: green)) {
        return "B"
    } else if (yellowColor(red: red, blue: blue, green: green)) {
        return "Y"
    } else if (whiteColor(red: red, blue: blue, green: green)) {
        return "W"
    }
    return "H"
}

func whiteColor(red: CGFloat, blue: CGFloat, green: CGFloat) -> Bool{
    
    if red > 130 && blue > 130 && green > 130{
        return true
    }
    
    return false
}

func yellowColor(red: CGFloat, blue: CGFloat, green: CGFloat) -> Bool{
    
    if red + 20 >= green && red - 20 <= green && blue < 120 {
        return true
    }
    
    return false
}

func blueColor(red: CGFloat, blue: CGFloat, green: CGFloat) -> Bool {
    
    if red + green < blue {
        return true
    }
    
    return false
}

func greenColor(red: CGFloat, blue: CGFloat, green: CGFloat) -> Bool {
    if red + blue < green {
        return true
    }
    
    return false
}

func redColor(red: CGFloat, blue: CGFloat, green: CGFloat) -> Bool {
    if green + blue < red {
        return true
    }
    return false
}

func orangeColor(red: CGFloat, blue: CGFloat, green: CGFloat) -> Bool {
    if green + blue < red {
        return true
    }
    return false
}

func redOrangeDecider(red: CGFloat, blue: CGFloat, green: CGFloat) -> String {
//    let combo = blue + green
    let combo = blue + blue/2
//    print(red,green,blue," <- RGB VALUES")
    if green > 90 && green > combo{
        return "O"
    }
    
    return "R"
}

func squareColor(color: String) -> Color {
    switch color{
    case "G":
        return Color.green
    case "B":
        return Color.blue
    case "Y":
        return Color.cgYellow
    case "W":
        return Color.white
    case "R":
        return Color.red
    case "O":
        return Color.orange
    default:
        return Color.secondary
    }
}
