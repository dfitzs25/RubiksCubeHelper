//
//  CameraView.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/2/22.
//CircleView()
//    .position(x: 120, y: 250)
//CircleView()
//    .position(x: 190, y: 250)
//CircleView()
//    .position(x: 260, y: 250)
//CircleView()
//    .position(x: 120, y: 320)
//CircleView()
//    .position(x: 190, y: 390)
//CircleView()
//    .position(x: 260, y: 320)
//CircleView()
//    .position(x: 260, y: 390)
//CircleView()
//    .position(x: 120, y: 390)

import SwiftUI
import PureSwiftUI

struct CameraView: View {
    
    @EnvironmentObject var pcv: PhotoCaptureView
    @EnvironmentObject var gv: GridVitals
    @State var noPhoto = true
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = pcv.image {
                    ZStack{
                        Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 350, maxHeight: 500)
//                        .padding(.horizontal)
                        GridView()
                            .environmentObject(GridVitals())
                            .environmentObject(PhotoCaptureView())
                    }
                    HStack {
                        Button {
                            pcv.source = .camera
                            pcv.showPhotoPicker()
                        } label: {
                            Text("Retake")
                        }
                        Button {
                            pcv.source = .library
                            pcv.showPhotoPicker()
                        } label: {
                            Text("Library")
                        }
                        Button {
                            let pc = PixelCalculator()
                            setPicValues(width: CGFloat(image.pixelWidth), height: CGFloat(image.pixelHeight))
                            findPixelColor(image: image, x: pc.findXValue(posChange: true, mag: gv.magnificiation, offset: gv.offset), y: pc.findYValue(posChange: true, mag: gv.magnificiation, offset: gv.offset))
                        } label: {
                            Text("Process")
                        }
                        
                    }.padding(.top, 6.0)
                    Spacer()
                } else {
                    ZStack{
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .opacity(0.6)
                            .frame(maxWidth: 350, maxHeight: 500)
                            .padding(.horizontal)
                    }
                }
                if noPhoto {
                    HStack {
                        Button {
                            pcv.source = .camera
                            pcv.showPhotoPicker()
                            noPhoto = false
                        } label: {
                            Text("Camera")
                        }
                        Button {
                            pcv.source = .library
                            pcv.showPhotoPicker()
                            noPhoto = false
                        } label: {
                            Text("Photos")
                        }
                    }.padding(.top, 6.0)
                    Spacer()
                }
            }
            .sheet(isPresented: $pcv.showPicker) {
                ImagePicker(sourceType: pcv.source == .library ? .photoLibrary : .camera, selectedImage: $pcv.image)
                    .ignoresSafeArea()
            }
            .navigationTitle("My Images")
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
            .environmentObject(PhotoCaptureView())
            .environmentObject(GridVitals())
        
    }
}