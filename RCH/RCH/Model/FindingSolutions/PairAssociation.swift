//
//  PairAssociation.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/10/22.
//

import Foundation


struct EdgePairs {
    private let doorA = [1,5,3,7,21,23,34,26,37,40,30,43]
    private let doorB = [19,16,10,13,32,24,48,27,46,50,29,52]
    
    func associatePair(piece: Int) -> Int{
        if let pos = doorA.firstIndex(of: piece) {
            let other = doorB[pos]
            return other
        } else if let pos = doorB.firstIndex(of: piece) {
            let other = doorA[pos]
            return other
        }
        return -1
    }
}

struct CornerPairs {
    private let doorA = [8 ,2 ,6 ,0,45,51,47,53]
    private let doorB = [14,17,12,20,36,33,38,41]
    private let doorC = [15,18,11,9,35,44,39,42]
    
    func associatePair(piece: Int) -> (Int, Int) {
        if let pos = doorA.firstIndex(of: piece) {
            let other1 = doorB[pos]
            let other2 = doorC[pos]
            return (other1, other2)
        } else if let pos = doorB.firstIndex(of: piece) {
            let other1 = doorA[pos]
            let other2 = doorC[pos]
            return (other1, other2)
        } else if let pos = doorC.firstIndex(of: piece) {
            let other1 = doorB[pos]
            let other2 = doorA[pos]
            return (other1, other2)
        }
        return ( -1, -1)
    }
}
