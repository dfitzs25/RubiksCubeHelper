//
//  RubiksGridShape.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/4/22.
//

import Foundation
import SwiftUI
import PureSwiftUI

private let gridLayout = LayoutGuideConfig.grid(columns: 3, rows: 3)

private typealias Curve = (p: CGPoint, cp1: CGPoint, cp2: CGPoint)

private var processed = false

private func curveMaker(point: CGPoint) -> Curve {
    return Curve(point,point,point)
}

struct RubkisGrid: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let g = gridLayout.layout(in: rect)
        
        //maiking the points for the actual shapes
        
        //top left corner
        let c11 = g[0,0]
        let c12 = g[0,1]
        let c13 = g[1,0]
        let c14 = g[1,1]
        //c13 and c14 relate to top edge
        //c14 and c12 relate to middle left edge
        //top right corner
        let c21 = g[3,0]
        let c22 = g[3,1]
        let c23 = g[2,0]
        let c24 = g[2,1]
        //c23 and c24 relate to top edge
        //c24 and c22 relate to middle right edge
        //bottome left corner
        let c31 = g[0,2]
        let c32 = g[1,2]
        let c33 = g[0,3]
        let c34 = g[1,3]
        //c31 and c32 relate to middle left edge
        //c34 and c33 relate to bottom edge
        //bottom right corner
        let c41 = g[3,2]
        let c42 = g[3,3]
        let c43 = g[2,2]
        let c44 = g[2,3]
        //c44 and c43 relate to bottom edge
        //c41 and c43 rleate to middle right edge
        
        var curves = [Curve]()
        
        //add all points in order to the curves list
        curves.append(curveMaker(point: c12))
        curves.append(curveMaker(point: c14))
        curves.append(curveMaker(point: c13))
        curves.append(curveMaker(point: c11))
        //corner 2
        curves.append(curveMaker(point: c21))
        curves.append(curveMaker(point: c22))
        curves.append(curveMaker(point: c24))
        curves.append(curveMaker(point: c23))
        curves.append(curveMaker(point: c21))
        //corner 3
        curves.append(curveMaker(point: c41))
        curves.append(curveMaker(point: c42))
        curves.append(curveMaker(point: c44))
        curves.append(curveMaker(point: c43))
        curves.append(curveMaker(point: c44))
        //corner 4
        curves.append(curveMaker(point: c34))
        curves.append(curveMaker(point: c33))
        curves.append(curveMaker(point: c31))
        curves.append(curveMaker(point: c32))
        curves.append(curveMaker(point: c34))
        curves.append(curveMaker(point: c32))
        curves.append(curveMaker(point: c31))
        //fill in last lines
        curves.append(curveMaker(point: c12))
        curves.append(curveMaker(point: c14))
        curves.append(curveMaker(point: c32))
        curves.append(curveMaker(point: c41))
        curves.append(curveMaker(point: c43))
        curves.append(curveMaker(point: c24))
        curves.append(curveMaker(point: c14))
        //go through the list and draw them
        path.move(to: c11)
        
        for curve in curves {
            path.curve(curve.p, cp1: curve.cp1, cp2: curve.cp2)
        }
        
        return path
    }
}

var widthSet = false
var heightSet = false
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
        let magFrame = (frame * mag)
        let change = magFrame / 3
        let xOffset = offset.x * mag
        var final = 0.0
        
        if xBool {
            final = (width/2) + change + xOffset
        } else {
            final = (width/2) - change + xOffset
        }
        
        return final
    }
    
    func setHeight(geo: GeometryProxy) -> CGFloat {
        let height = geo.size.height
        if !heightSet {
            setGridHeight(height: height)
            heightSet = true
        }
        let magFrame = (frame * mag)
        let change = magFrame / 3
        let yOffset = offset.y * mag
        var final = 0.0
        
        if yBool {
            final = (height/2) + change + yOffset
        } else {
            final = (height/2) - change + yOffset
        }
        
        return final
//        return pc.findYValue(posChange: false)
    }
    
    func getColor(geo: GeometryProxy) -> Color {
        if processed{
            let y = setHeight(geo: geo)
            let x = setWidth(geo: geo)

            let uiColor = findPixelColor(image: image, x: x, y: y)

            let color = Color.init(uiColor: uiColor)
            let colorString = idColor(color: uiColor)
            print("GOT THE COLOR - Corner:",colorString)
            return color
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
    
    func setWidth() -> CGFloat{
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
    
    func setHeight() -> CGFloat {
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
    
    func getColor() -> Color {
        if processed{
            let y = setHeight()
            let x = setWidth()

            let uiColor = findPixelColor(image: image, x: x, y: y)

            let color = Color.init(uiColor: uiColor)
            let colorString = idColor(color: uiColor)
            print("GOT THE COLOR - Corner:",colorString)
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
                .position(x: setWidth(), y: setHeight())
        }
    }
}

func resetColorSystem() {
    processed = false
}

struct GridView: View {
    
    @EnvironmentObject var gv: GridVitals
    var image: UIImage
    
    var body: some View {
        VStack{
            Text("Take a Picture of the WHITE SIDE.")
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
                gv.WiggleDots()
                setPicValues(width: CGFloat(image.size.width), height: CGFloat(image.size.height))
            } label: {
                Text("Process")
            }
        }
    }
}
