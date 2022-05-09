//
//  RubiksGridShape.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/4/22.
//

import Foundation
import SwiftUI

private var processed = false
private var widthSet = false
private var heightSet = false
private var side: Int = 0
private var colors = ["E","E","E","E","E","E","E","E","E"]
///Responsible for helping the user line up their peices on the grid
///as well as show the colors beign read by the system
struct CornerPiece: View {
    
    @EnvironmentObject var gv: GridVitals
    @Binding var mag: CGFloat
    @Binding var offset: CGSize
    var xBool: Bool
    var yBool: Bool
    var image: UIImage
    var color: Color = .gray
    let frame = 220.0
    
    func setWidth(geo: GeometryProxy) -> CGFloat{
        let width = geo.size.width
        if !widthSet{
            setGridWidth(width: width)
            widthSet = true
        }
        return cornerXPosition(frame: frame, mag: mag, offset: offset, xBool: xBool)
    }
    
    func setHeight(geo: GeometryProxy) -> CGFloat {
        let height = geo.size.height
        if !heightSet {
            setGridHeight(height: height)
            heightSet = true
        }
        return cornerYPosition(frame: frame, mag: mag, offset: offset, yBool: yBool)
    }
    
    func getColor(geo: GeometryProxy) -> Color {
        if processed{
            let y = setHeight(geo: geo)
            let x = setWidth(geo: geo)

            let uiColor = findPixelColor(image: image, x: x, y: y)

            let colorString = idColor(color: uiColor)
            //map color to the rubik's cube model
            let pos = getCornerIntPosition(xBool: xBool, yBool: yBool)
//            print("Corner:",colorString,"Position:",pos, "Side:", side)
            mapColorToSide(side: side, color: colorString, pos: pos)
            return Color.init(uiColor: uiColor)
        } else {
            return .gray
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            //center Circle
            Circle()
                .fill(getColor(geo: geometry))
                .frame(20)
                .position(x: setWidth(geo: geometry), y: setHeight(geo: geometry))
        }
    }
}
///This creates the view for the edge peices
///This shares a lot with CornerPiece however the setWidth and setHeigh needed to be edited
struct EdgePiece: View {
    
    @EnvironmentObject var gv: GridVitals
    @Binding var mag: CGFloat
    @Binding var offset: CGSize
    var xBool: Bool
    var yBool: Bool
    var xSame: Bool
    var image: UIImage
    let frame = 220.0
    
    func getColor() -> Color {
        if processed{
            let y = edgeYPosition(frame: frame, mag: mag, offset: offset, yBool: yBool, xSame: xSame)
            let x = edgeXPosition(frame: frame, mag: mag, offset: offset, xBool: xBool, xSame: xSame)

            let uiColor = findPixelColor(image: image, x: x, y: y)

            let color = Color.init(uiColor: uiColor)
            let colorString = idColor(color: uiColor)
            //mapping color to rubik's cube model
            let pos = getEdgeIntPosition(xBool: xBool, yBool: yBool, xSame: xSame)
            mapColorToSide(side: side, color: colorString, pos: pos)
            return color
        } else {
            return .gray
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .fill(getColor())
                .frame(20)
                .position(x: edgeXPosition(frame: frame, mag: mag, offset: offset, xBool: xBool, xSame: xSame), y: edgeYPosition(frame: frame, mag: mag, offset: offset, yBool: yBool, xSame: xSame))
        }
    }
}



func resetColorSystem() {
    processed = false
}

func setSide(current: Int) {
    side = current
}

struct GridView: View {
    
    @EnvironmentObject var gv: GridVitals
    var image: UIImage
    @Binding var side: Int
    @Binding var gridText: String 
    
    var body: some View {
        VStack{
            Text(gridText)
            ZStack {
                RubkisGrid()
                    .stroke(Color.black, lineWidth: 4)
                    .frame(220)
                    .offset(gv.offset)
                    .scaleEffect(gv.magnificiation)
                    .gesture(
                        DragGesture()
                            .onChanged{
                                value in gv.offset = value.translation
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ value in
                                gv.magnificiation = value
                            })
                )
                //corner peices
                CornerPiece(mag: $gv.magnificiation,offset: $gv.offset, xBool: true, yBool: false, image: image)
                    .environmentObject(GridVitals())
                CornerPiece(mag: $gv.magnificiation,offset: $gv.offset, xBool: false, yBool: true, image: image)
                    .environmentObject(GridVitals())
                CornerPiece(mag: $gv.magnificiation,offset: $gv.offset, xBool: false, yBool: false, image: image)
                    .environmentObject(GridVitals())
                CornerPiece(mag: $gv.magnificiation,offset: $gv.offset, xBool: true, yBool: true, image: image)
                    .environmentObject(GridVitals())
                //edge peices
                EdgePiece(mag: $gv.magnificiation, offset: $gv.offset, xBool: true, yBool: true, xSame: false, image: image)
                    .environmentObject(GridVitals())
                EdgePiece(mag: $gv.magnificiation, offset: $gv.offset, xBool: false, yBool: true, xSame: false, image: image)
                    .environmentObject(GridVitals())
                EdgePiece(mag: $gv.magnificiation, offset: $gv.offset, xBool: true, yBool: false, xSame: true, image: image)
                    .environmentObject(GridVitals())
                EdgePiece(mag: $gv.magnificiation, offset: $gv.offset, xBool: true, yBool: true, xSame: true, image: image)
                    .environmentObject(GridVitals())
            }
            Button {
                processed = true
                setSide(current: side)
                gv.WiggleDots()
                setPicValues(width: CGFloat(image.size.width), height: CGFloat(image.size.height))
            } label: {
                Text("Process")
            }
//            Button {
//
//                print(formatCubeSide(side: side))
//            } label: {
//                Text("TEST FORMATING")
//            }
        }
    }
}
