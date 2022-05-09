//
//  ColorFixing.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/7/22.
//

import Foundation
import SwiftUI

private var position = -1

func setPosition(pos: Int) {
    position = pos
}

func getChangePosition() -> Int {
    return position
}

func noMissingColors() -> Bool {
    //TODO: switch back to actuall array
    let nums = [1,2,3,4,5,6]
    for num in nums {
        let side = getCubeSideArrayTest(side: num)
        if side.contains("H") {
            return false
        }
    }
    return true
}

struct SideSelector: View {
    
    let width: CGFloat
    let height: CGFloat
    @State var isPresent: Bool = false
    @State var currentSide: Int = 0
    @State var reRender: Bool = false
    
    var body: some View {
        VStack{
            ZStack{
                if reRender {
                    CubeSideButton(side: 1, width: width, height: height, isPresent: $isPresent, selectSide: $currentSide)
                    CubeSideButton(side: 2, width: width, height: height, isPresent: $isPresent, selectSide: $currentSide)
                    CubeSideButton(side: 3, width: width, height: height, isPresent: $isPresent, selectSide: $currentSide)
                    CubeSideButton(side: 4, width: width, height: height, isPresent: $isPresent, selectSide: $currentSide)
                    CubeSideButton(side: 5, width: width, height: height, isPresent: $isPresent, selectSide: $currentSide)
                    CubeSideButton(side: 6, width: width, height: height, isPresent: $isPresent, selectSide: $currentSide)
                } else {
                    CubeSideButton(side: 1, width: width, height: height, isPresent: $isPresent, selectSide: $currentSide)
                    CubeSideButton(side: 2, width: width, height: height, isPresent: $isPresent, selectSide: $currentSide)
                    CubeSideButton(side: 3, width: width, height: height, isPresent: $isPresent, selectSide: $currentSide)
                    CubeSideButton(side: 4, width: width, height: height, isPresent: $isPresent, selectSide: $currentSide)
                    CubeSideButton(side: 5, width: width, height: height, isPresent: $isPresent, selectSide: $currentSide)
                    CubeSideButton(side: 6, width: width, height: height, isPresent: $isPresent, selectSide: $currentSide)
                }
            }
            if noMissingColors() {
                Button {
                    print("GET SOLUTION")
                } label: {
                    Text("FIND SOLUTION")
                        .bold()
                        .position(x: width/2, y: height/6)
                        .title2Font()
                }
            } else {
                Text("Select Sides which need to be fixed")
                    .bold()
                    .position(x: width/2, y: height/6)
                    .title2Font()
            }
            
        }.sheet(isPresented: $isPresent) {
            SheetView(side: $currentSide, reRender: $reRender)
        }
    }
}

private struct CubeSideButton: View {
    
    let side: Int
    let width: CGFloat
    let height: CGFloat
    @Binding var isPresent: Bool
    @Binding var selectSide: Int
    
    func frameWidth() -> CGFloat {
        switch side {
        case 3:
            return width/2.6 + 90
        case 1:
            return width/2.6 - 90
        case 4:
            return width/2.6 + 180
        default:
            return width/2.6
        }
    }
    
    func frameHeight() -> CGFloat{
        if side <= 4 {
            return height/7 + 90
        } else if side == 6 {
            return height/7 + 180
        }
        return height/7
    }
    
    func findWidth() -> CGFloat {
        return width/2.6 - (80 * 1.3)
    }
    
    func findHeight() -> CGFloat {
        return height/7 - (80 * 0.95)
    }
    
    var body: some View{
        Button {
            isPresent = true
            selectSide = side
        } label: {
            CubeSide(side: getCubeSideArrayTest(side: side),width: findWidth(), height: findHeight())
        }.frame(80)
            .position(x: frameWidth(), y: frameHeight())
    }
}

//NOTE: This is the exact same as the method in RubiksCubeModel to make a side, only difference are the squares are now buttons
struct SideColorEditor: View {
    let positions = [1,2,3,4,5,6,7,8,9]
    var side: [String]
    var frameSize: CGFloat = 300
    var ogX = UIScreen.main.bounds.width/2
    var ogY = UIScreen.main.bounds.height/4
    @Binding var sr: Bool
    
    var body: some View {
        ZStack {
            RubkisGrid()
                .stroke(Color.secondary, lineWidth: 2)
                .frame(frameSize)
                .background(.secondary)
                .position(x: ogX, y: ogY)
                ForEach(0..<9) { i in
                    RubikButtonSquare(color: side[i], ogX: ogX, ogY: ogY, pos: i + 1, sr: $sr)
                }
        }
    }
}

struct RubikButtonSquare: View {
    
    var color: String
    var ogX: CGFloat
    var ogY: CGFloat
    var pos: Int
    let frameSize: CGFloat = 300
    @Binding var sr: Bool
    
    func changeXPosition() -> CGFloat{
        if pos == 1  || pos == 7{
//            return pos - gridWidth/2 - frameSize/2
            return cornerXPosition(frame: frameSize, mag: 1, offset: CGSize(ogX, ogY), xBool: false) - gridWidth/2
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
            return cornerYPosition(frame: frameSize, mag: 1, offset: CGSize(ogX,ogY), yBool: false) - gridHeight/2
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
            Button {
                if pos != 5 {
                    setPosition(pos: pos)
                } else {
                    setPosition(pos: -1)
                }
                sr = !sr
            } label: {
                Rectangle()
                    .foregroundColor(squareColor(color: color))
            }.frame(95)
                .position(x: changeXPosition(), y: changeYPosition())
        }
        else {
            Button {
                if pos != 5 {
                    setPosition(pos: pos)
                } else {
                    setPosition(pos: -1)
                }
                sr = !sr
            } label: {
                MissingColor(frame: 95)
                    .foregroundColor(squareColor(color: color))
            }.frame(95)
                .position(x: changeXPosition(), y: changeYPosition())
        }
    }
}

struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var side: Int
    @State var sheetRender: Bool = false
    @Binding var reRender: Bool
    
    func nicerText() -> String {
        switch getChangePosition() {
        case 1:
            return "Change the Color of Square 1 to..."
        case 2:
            return "Change the Color of Square 2 to..."
        case 3:
            return "Change the Color of Square 3 to..."
        case 4:
            return "Change the Color of Square 4 to..."
        case 6:
            return "Change the Color of Square 6 to..."
        case 7:
            return "Change the Color of Square 7 to..."
        case 8:
            return "Change the Color of Square 8 to..."
        case 9:
            return "Change the Color of Square 9 to..."
        default:
            return "Select a Square to change color "
        }
    }
    
    func colorSafeGaurd(color: String){
        if getChangePosition() != -1 {
            mapColorToSideTest(side: side, color: color, pos: getChangePosition())
        }
    }
    
    var body: some View {
        ZStack{
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                 Image(systemName: "xmark")
                    .foregroundColor(.red)
                    .largeTitleFont()
                    .padding(20)
                    .position(x: 20, y: 20)
            }
            //TODO: Change this to be normal getCubeSideArray
            if !sheetRender {
                SideColorEditor(side: getCubeSideArrayTest(side: side), sr: $sheetRender)
            } else {
                SideColorEditor(side: getCubeSideArrayTest(side: side), sr: $sheetRender)
            }
            Text(nicerText())
                .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
            VStack{
                HStack{
                    VStack{
                        Button {
                            colorSafeGaurd(color: "B")
                            sheetRender = !sheetRender
                            reRender = !reRender
                        } label: {
                            Text("Blue")
                                .foregroundColor(.primary)
                                .title2Font()
                                .width(100)
                                .backgroundColor(.secondary)
                                .cornerRadius(20)
                                .padding(10)
                        }
                        Button {
                            colorSafeGaurd(color: "R")
                            sheetRender = !sheetRender
                            reRender = !reRender
                        } label: {
                            Text("Red")
                                .foregroundColor(.primary)
                                .title2Font()
                                .width(100)
                                .backgroundColor(.secondary)
                                .cornerRadius(20)
                                .padding(10)
                            

                        }
                        Button {
                            colorSafeGaurd(color: "W")
                            sheetRender = !sheetRender
                            reRender = !reRender
                        } label: {
                            Text("White")
                                .foregroundColor(.primary)
                                .title2Font()
                                .width(100)
                                .backgroundColor(.secondary)
                                .cornerRadius(20)
                                .padding(10)

                        }
                    }
                    VStack{
                        Button {
                            colorSafeGaurd(color: "G")
                            sheetRender = !sheetRender
                            reRender = !reRender
                        } label: {
                            Text("Green")
                                .foregroundColor(.primary)
                                .title2Font()
                                .width(100)
                                .backgroundColor(.secondary)
                                .cornerRadius(20)
                                .padding(10)

                        }
                        Button {
                            colorSafeGaurd(color: "O")
                            sheetRender = !sheetRender
                            reRender = !reRender
                        } label: {
                            Text("Orange")
                                .foregroundColor(.primary)
                                .title2Font()
                                .width(100)
                                .backgroundColor(.secondary)
                                .cornerRadius(20)
                                .padding(10)

                        }
                        Button {
                            colorSafeGaurd(color: "Y")
                            sheetRender = !sheetRender
                            reRender = !reRender
                        } label: {
                            Text("Yellow")
                                .foregroundColor(.primary)
                                .title2Font()
                                .width(100)
                                .backgroundColor(.secondary)
                                .cornerRadius(20)
                                .padding(10)

                        }
                    }
                }.position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/1.5)
            }
            
        }
    }
}

