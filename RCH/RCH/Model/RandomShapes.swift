//
//  RandomShapes.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/7/22.
//

import Foundation
import SwiftUI
import PureSwiftUI

private let gridLayout = LayoutGuideConfig.grid(columns: 1, rows: 1)

private typealias Curve = (p: CGPoint, cp1: CGPoint, cp2: CGPoint)

private func curveMaker(point: CGPoint) -> Curve {
    return Curve(point,point,point)
}

struct CustomCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let g = LayoutGuideConfig.grid(columns: 4, rows: 4).layout(in: rect)
        //main points
        let p1 = g[0,2]
        let p2 = g[2,0]
        let p3 = g[4,2]
        let p4 = g[2,4]
        //accent points
        let a1 = g[0,0]
        let a2 = g[4,0]
        let a3 = g[4,4]
        let a4 = g[0,4]
        
        var curves = [Curve]()
        
        curves.append(Curve(p2,a1,p2))
        curves.append(Curve(p3,a2,p3))
        curves.append(Curve(p4,a3,p4))
        curves.append(Curve(p1,a4,p1))
        
        path.move(p1)
        
        for curve in curves {
            path.curve(curve.p, cp1: curve.cp1, cp2: curve.cp2)
        }
        
        return path
    }
}

struct Cross: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let g = gridLayout.layout(in: rect)
        
        let p1 = g[0,0]
        let p2 = g[1,0]
        let p3 = g[1,1]
        let p4 = g[0,1]
        let p5 = g[rel: 0.5,rel: 0.5]
        
        var curves = [Curve]()
        
        curves.append(curveMaker(point: p5))
        curves.append(curveMaker(point: p2))
        curves.append(curveMaker(point: p5))
        curves.append(curveMaker(point: p3))
        curves.append(curveMaker(point: p5))
        curves.append(curveMaker(point: p4))
        
        path.move(p1)
        
        for curve in curves {
            path.curve(curve.p, cp1: curve.cp1, cp2: curve.cp2)
        }
        
        return path
    }
}


struct SelectedColor: View{
    let frame: CGFloat
    func crossFrame() -> CGFloat {
        return frame * 0.75
    }
    
    var body: some View {
        ZStack{
            CustomCircle()
                .stroke(Color.green,lineWidth: frame/15)
                .frame(frame)
        }
    }
}

struct MissingColor: View{
    let frame: CGFloat
    func crossFrame() -> CGFloat {
        return frame * 0.75
    }
    
    var body: some View {
        ZStack{
            CustomCircle()
                .stroke(Color.red,lineWidth: frame/15)
                .frame(frame)
            Cross()
                .stroke(Color.red, lineWidth: frame/5)
                .frame(crossFrame())
        }
    }
}
