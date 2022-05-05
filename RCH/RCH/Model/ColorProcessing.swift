//
//  ColorProcessing.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/5/22.
//

import Foundation
import UIKit

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
    return "UNKOWN"
}

func whiteColor(red: CGFloat, blue: CGFloat, green: CGFloat) -> Bool{
    
    if red > 150 && blue > 150 && green > 150{
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
    let combo = blue + green
    if combo / red >= 0.5 {
        return "O"
    }
    
    return "R"
}
