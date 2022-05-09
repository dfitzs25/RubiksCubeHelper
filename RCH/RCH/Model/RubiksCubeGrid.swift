//
//  RubiksCubeGrid.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/5/22.
//

import Foundation
import SwiftUI
import PureSwiftUI

private let gridLayout = LayoutGuideConfig.grid(columns: 3, rows: 3)

private typealias Curve = (p: CGPoint, cp1: CGPoint, cp2: CGPoint)

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
