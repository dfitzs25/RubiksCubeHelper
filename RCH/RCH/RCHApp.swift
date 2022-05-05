//
//  RCHApp.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/2/22.
//

import SwiftUI

@main
struct RCHApp: App {
    var body: some Scene {
        WindowGroup {
            CameraView()
                .environmentObject(PhotoCaptureView())
                .environmentObject(GridVitals())
        }
    }
}
