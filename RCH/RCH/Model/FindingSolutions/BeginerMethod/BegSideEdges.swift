//
//  BegSideEdges.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/13/22.
//

import Foundation

///Steps:
///get all edge pieces without white on them
///see if a edge piece is solved
///check if all edge pieces are solved
///BONUS - make method to tell if piece is 'unstuck' or easy to solve
///align edge piece properly
///slot edge piece into place
///remove corner + bad edge combo
///replace corner
///insert edge correctly

class BegSideEdges {
    var sm: SolveModel
    var moves = ""
    var unsolvedEdges = [Int]()
    var ep = EdgePairs()
    
    init(sm: SolveModel){
        self.sm = sm
    }
    
    func solveBegSideEdges() {
        
    }
}
