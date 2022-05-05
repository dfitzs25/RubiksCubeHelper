//
//  ContentView.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/2/22.
//

import SwiftUI
import PureSwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(200)
                .colorInvert()
                .border(.red)
            
            GeometryReader { geometry in
                Circle()
                    .frame(20)
                    .position(x: geometry.size.width/2, y: geometry.size.height/2)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
