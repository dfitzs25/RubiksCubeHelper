//
//  PhotoCaptureView.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/2/22.
//

//MEANT TO SHOW IMAGEVIEW YOU TOOK

import SwiftUI



class PhotoCaptureView: ObservableObject {
    @Published var image: UIImage?
    @Published var showPicker = false
    @Published var source: Picker.Source = .library
    
    func showPhotoPicker() {
        if source == .camera {
            if !Picker.checkPermissions() {
                print("There is no camera on this device")
                return
            }
        }
        showPicker = true
    }
    
}
