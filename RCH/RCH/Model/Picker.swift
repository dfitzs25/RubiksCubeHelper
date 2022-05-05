//
//  Picker.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/4/22.
//

import UIKit

enum Picker {
    enum Source: String {
        case library, camera
    }
    
    static func checkPermissions() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            return true
        } else {
            return false
        }
    }
}
