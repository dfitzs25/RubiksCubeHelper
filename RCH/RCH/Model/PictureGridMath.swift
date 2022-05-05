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
}

func setGridHeight(height: CGFloat) {
    gridHeight = height
}

func setPicValues(width: CGFloat, height: CGFloat) {
    picWidth = width
    picHeight = height
    //Grid will be filled in by now
    widthRatio = picWidth/gridWidth
    heightRatio = picHeight/gridHeight
//    print("Ratio Values")
//    print(widthRatio)
//    print(heightRatio)
}

func findPixelColor(image: UIImage, x: CGFloat, y: CGFloat) {
    let color = image.pixelColor(x: Int(x), y: Int(y))
    print(color)
}

struct PixelCalculator {
    
    let frame = 220.0
    
    //true for Positive shift false for negative shift
    func findXValue(posChange: Bool, mag: CGFloat, offset: CGSize) -> CGFloat {
        let magFrame = (frame * mag)
        let change = magFrame / 3
        let xOffset = offset.x * mag
        let grid = (gridWidth/2) + xOffset
        
        
        if posChange {
            print(grid + change)
            print(picWidth)
            print( (grid + change) * widthRatio )
            return (grid + change) * widthRatio
        } else {
            print(grid - change)
            print(picWidth)
            print( (grid - change) * widthRatio )
            return (grid - change) * widthRatio
        }
    }
    
    func findYValue(posChange: Bool, mag: CGFloat, offset: CGSize) -> CGFloat {
        let magFrame = (frame * mag)
        let change = magFrame / 3
        let yOffset = offset.y * mag
        let grid = (gridHeight/2) + yOffset
        
        if posChange {
            print(grid + change)
            print(picHeight)
            print( (grid + change) * heightRatio )

            return (grid + change) * heightRatio
        } else {
            print(grid - change)
            print(picHeight)
            print( (grid - change) * heightRatio )

            return (grid - change) * heightRatio
        }
    }
}

func pixYVal(value: CGFloat) -> CGFloat {
    return (value * heightRatio)
}

func pixXVal(value: CGFloat) -> CGFloat {
    return (value * widthRatio)
}

class GridVitals: ObservableObject {
    @Published var offset: CGSize = .zero
    @Published var magnificiation: CGFloat = 1
}
