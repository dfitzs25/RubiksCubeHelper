//
//  PictureGridMath.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/4/22.
//

import Foundation
import SwiftUI

var picWidth: CGFloat = 0
var picHeight: CGFloat = 0
var gridWidth: CGFloat = 0
var gridHeight: CGFloat = 0
//private variables
private var widthRatio: CGFloat = 0
private var heightRatio: CGFloat = 0


func setGridWidth(width: CGFloat) {
    gridWidth = width
    print("GRID WIDTH",gridWidth)
}

func setGridHeight(height: CGFloat) {
    gridHeight = height
    print("GRID HEIGHT",gridHeight)
}

func setPicValues(width: CGFloat, height: CGFloat) {
    picWidth = width
    picHeight = height
    //Grid will be filled in by now
    widthRatio = picWidth/gridWidth
    heightRatio = picHeight/gridHeight
}

func findPixelColor(image: UIImage, x: CGFloat, y: CGFloat) -> UIColor{
    let newX = x * widthRatio
    let newY = Int(y * heightRatio)
    let finY = picWidth - newX
    //The x and Y values are swapped because the photo's pixels start at the bottom left
    //corner whereas the ImageView starts top left. 
    let color = image.pixelColor(x: newY, y: Int(finY))
    return color
}

func getCornerIntPosition(xBool: Bool, yBool: Bool) -> Int {
    if xBool && yBool {
        return 9
    } else if  xBool && !yBool {
        return 3
    } else if  !xBool && yBool{
        return 7
    } else {
        return 1
    }
}

func getEdgeIntPosition(xBool: Bool, yBool: Bool, xSame: Bool) -> Int{
    if xSame {
        if yBool {
            return 8
        } else {
            return 2
        }
    } else if xBool {
        return 6
    } else {
        return 4
    }
}

func cornerXPosition(frame: Double,mag: CGFloat, offset: CGSize, xBool: Bool) -> CGFloat{
    let magFrame = (frame * mag)
    let change = magFrame / 3
    let xOffset = offset.x * mag
    var final = 0.0
    
    if xBool {
        final = (gridWidth/2) + change + xOffset
    } else {
        final = (gridWidth/2) - change + xOffset
    }
    return final
}

func cornerYPosition(frame: Double,mag: CGFloat, offset: CGSize, yBool: Bool) -> CGFloat{
    let magFrame = (frame * mag)
    let change = magFrame / 3
    let yOffset = offset.y * mag
    var final = 0.0

    if yBool {
        final = (gridHeight/2) + change + yOffset
    } else {
        final = (gridHeight/2) - change + yOffset
    }
    return final
}

func edgeXPosition(frame: Double,mag: CGFloat, offset: CGSize, xBool: Bool, xSame:Bool) -> CGFloat{
    let magFrame = (frame * mag)
    let change = magFrame / 3
    let xOffset = offset.x * mag
    var final = 0.0
    
    if xBool && !xSame {
        final = (gridWidth/2) + change + xOffset
    } else if !xSame {
        final = (gridWidth/2) - change + xOffset
    } else {
        final = (gridWidth/2) + xOffset
    }
    
    return final
}

func edgeYPosition(frame: Double,mag: CGFloat, offset: CGSize, yBool: Bool, xSame:Bool) -> CGFloat{
    let magFrame = (frame * mag)
    let change = magFrame / 3
    let yOffset = offset.y * mag
    var final = 0.0
    
    if yBool && xSame{
        final = (gridHeight/2) + change + yOffset
    } else if xSame{
        final = (gridHeight/2) - change + yOffset
    } else {
        final = (gridHeight/2) + yOffset
    }
    
    return final
}

class GridVitals: ObservableObject {
    @Published var offset: CGSize = .zero
    @Published var magnificiation: CGFloat = 1
    @Published var side: Int = 1
    @Published var gridText: String = "Process the ORANGE SIDE(Yellow side towards you)"

    func WiggleDots(){
        magnificiation += 1
        magnificiation -= 1
    }
    
    func changeSide(){
        side += 1
        setGridText()
    }
    
    func setGridText(){
        switch side{
        case 2:
            gridText =  "Process the GREEN SIDE(Yellow side towards you)"
        case 3:
            gridText =  "Process the RED SIDE(Yellow side towards you)"
        case 4:
            gridText =  "Process the BLUE SIDE(Yellow side towards you)"
        case 5:
            gridText =  "Process the WHITE SIDE(GREEN side towards you)"
        case 6:
            gridText =  "Process the YELLOW SIDE(BLUE side towards you)"
        default:
            gridText =  "Does this look like your Cube?"
        }
    }
    
    func goToModelTesting(){
        gridText = "Does this look like your Cube?"
        side = 10
    }
}
