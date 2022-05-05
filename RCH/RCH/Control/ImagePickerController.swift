////
////  ImagePickerController.swift
////  RCH
////
////  Created by Dalton Fitzsimmons on 5/2/22.
////
//
//import Foundation
//import UIKit
//import SwiftUI
//
//
//class ImagePickerController: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
//
//    @Binding var isShown: Bool // a state to show image or not
//    @Binding var image: Image? // ? means can be null
//    
//    init(isShown: Binding<Bool>, image: Binding<Image?>) {
//        _isShown = isShown
//        _image = image
//    }
//    
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        //where you select a picture from photo library or after taking photo
//        
//        //casts the image as a usable type in swift
//        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        image = Image(uiImage: uiImage)
//        isShown = false
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        isShown = false
//    }
//}
