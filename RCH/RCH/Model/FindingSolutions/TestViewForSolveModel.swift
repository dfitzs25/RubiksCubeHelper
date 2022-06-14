//
//  TestViewForSolveModel.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/9/22.
//

import SwiftUI

var sm = SolveModel()
var bCross = BegSolveCross(sm: sm)
var bCorn = BegCorners(sm: sm)

struct ModelCubeForSolving: View {
    
    @State var solutionCross = ""
    @State var reRender = false
    @State var moves = ""
    
    func testSolution() {
        solutionCross = bCorn.solveCorners()
    }
    
    
    func testCreateModel() {
        sm.createModel()
    }
    
    var body: some View {
        VStack{
            if reRender {
                VStack {
                    ZStack{
                        CubeSide(side: getCubeSideArrayTest(side: 5),width: UIScreen.main.bounds.width/2.6, height: UIScreen.main.bounds.height/7)
                        CubeSide(side: getCubeSideArrayTest(side: 1),width: UIScreen.main.bounds.width/2.6 - 90, height: UIScreen.main.bounds.height/7 + 90)
                        CubeSide(side: getCubeSideArrayTest(side: 2),width: UIScreen.main.bounds.width/2.6, height: UIScreen.main.bounds.height/7 + 90)
                        CubeSide(side: getCubeSideArrayTest(side: 3),width: UIScreen.main.bounds.width/2.6 + 90, height: UIScreen.main.bounds.height/7 + 90)
                        CubeSide(side: getCubeSideArrayTest(side: 4),width: UIScreen.main.bounds.width/2.6 + 180, height: UIScreen.main.bounds.height/7 + 90)
                        CubeSide(side: getCubeSideArrayTest(side: 6),width: UIScreen.main.bounds.width/2.6 , height: UIScreen.main.bounds.height/7 + 180)
                    }
                    Text(solutionCross)
                }
            } else {
                VStack {
                    ZStack{
                        CubeSide(side: getCubeSideArrayTest(side: 5),width: UIScreen.main.bounds.width/2.6, height: UIScreen.main.bounds.height/7)
                        CubeSide(side: getCubeSideArrayTest(side: 1),width: UIScreen.main.bounds.width/2.6 - 90, height: UIScreen.main.bounds.height/7 + 90)
                        CubeSide(side: getCubeSideArrayTest(side: 2),width: UIScreen.main.bounds.width/2.6, height: UIScreen.main.bounds.height/7 + 90)
                        CubeSide(side: getCubeSideArrayTest(side: 3),width: UIScreen.main.bounds.width/2.6 + 90, height: UIScreen.main.bounds.height/7 + 90)
                        CubeSide(side: getCubeSideArrayTest(side: 4),width: UIScreen.main.bounds.width/2.6 + 180, height: UIScreen.main.bounds.height/7 + 90)
                        CubeSide(side: getCubeSideArrayTest(side: 6),width: UIScreen.main.bounds.width/2.6 , height: UIScreen.main.bounds.height/7 + 180)
                    }
                    Text(solutionCross)
                }
            }
            Button {
                testCreateModel()
            } label: {
                 Text("Test createModel")
            }
            Button {
                sm.setScramble()
                sm.deconstructModel()
                reRender = !reRender
            } label: {
                 Text("Test setScramble")
            }
            Button {
                solutionCross = bCross.solveBasicCross()
                sm.deconstructModel()
                reRender = !reRender
            } label: {
                Text("Test Solve Cross?")
            }
            
//            TextField("Enter Moves", text: $moves)
//            Button {
//                sm.applyMove(moveString: "B F2 R' B2 L' U2 L2 F2 R2 F2 D2 R D L' D2 R B U2 R U'")
//                sm.deconstructModel()
//                reRender = !reRender
//            } label: {
//                Text ("Submit Scramble moves")
//            }
            Button {
                print("STARTING THE CORNERS")
                solutionCross = bCorn.solveCorners()
                sm.deconstructModel()
                reRender = !reRender
            } label: {
                Text("Test Solve Bottom Corners?")
            }
            TextField("Enter Move", text: $moves)
            Button {
                sm.applyMove(moveString: moves)
                sm.deconstructModel()
                reRender = !reRender
            } label: {
                Text("S")
            }
            
            
//            Button {
//                sm.mPrimeTurn()
//                sm.deconstructModel()
//            } label: {
//                Text("test PrimeTurn")
//            }
//            Spacer()
        }
    }
}

struct TestViewForSolveModel_Previews: PreviewProvider {
    static var previews: some View {
        ModelCubeForSolving()
    }
}

