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
}

func findPixelColor(image: UIImage, x: CGFloat, y: CGFloat) -> UIColor{
//    print("BELOW ARE THE RATIONS IN ACTION")
//    print("X:",x * widthRatio, " GRID:",x)
//    print("Y:",y * heightRatio, " GRID:",y)
    
    let newX = x * widthRatio
    let newY = Int(y * heightRatio)
    let finY = picWidth - newX
    //The x and Y values are swapped because the photo's pixels start at the bottom left
    //corner whereas the ImageView starts top left. 
    let color = image.pixelColor(x: newY, y: Int(finY))
//    print(color)
    return color
}

class GridVitals: ObservableObject {
    @Published var offset: CGSize = .zero
    @Published var magnificiation: CGFloat = 1

    func WiggleDots(){
        magnificiation += 1
        magnificiation -= 1
    }
}
