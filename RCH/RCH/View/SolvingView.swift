//
//  CameraView.swift
//  RCH
//
//  Created by Dalton Fitzsimmons on 5/2/22.

import SwiftUI
import PureSwiftUI

struct SolvingPicture: View {
    @EnvironmentObject var pcv: PhotoCaptureView
    @EnvironmentObject var gv: GridVitals
    @State var noPhoto = true
    @Binding var showFinalCube: Bool
    
    func nextSlide(){
        gv.changeSide()
        if gv.side > 6 {
            showFinalCube = true
        }
        print(gv.side)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = pcv.image{
                        ZStack{
                            Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            GridView(image: image,side: $gv.side, gridText: $gv.gridText)
                                .environmentObject(GridVitals())
                        }
                        HStack {
                            Button {
                                pcv.source = .camera
                                pcv.showPhotoPicker()
                                resetColorSystem()
                            } label: {
                                Text("Retake")
                            }
                            Button {
                                pcv.source = .library
                                pcv.showPhotoPicker()
                                resetColorSystem()
                            } label: {
                                Text("Library")
                            }
                            Button{
                                resetColorSystem()
                                nextSlide()
                            } label: {
                                Text("Next Side")
                            }
                            Button {
                                showFinalCube = true
                            } label: {
                                Text("MODEL TESTING")
                            }
                        }
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
                        Button {
                            showFinalCube = true
                        } label: {
                            Text("MODEL TESTING")
                        }
                    }.padding(.top, 6.0)
                    Spacer()
                }
            }
            .sheet(isPresented: $pcv.showPicker) {
                ImagePicker(sourceType: pcv.source == .library ? .photoLibrary : .camera, selectedImage: $pcv.image)
                    .ignoresSafeArea()
            }
            .navigationTitle("Rubik's Cube Solver")
        }
    }
}

struct SolvingView: View {
    @EnvironmentObject var pcv: PhotoCaptureView
    @EnvironmentObject var gv: GridVitals
    @State var noPhoto = true
    @State var showFinalCube = false
    
    var body: some View {
        if !showFinalCube {
            SolvingPicture(showFinalCube: $showFinalCube)
                .environmentObject(PhotoCaptureView())
                .environmentObject(GridVitals())
        } else {
            VStack {
//                    ModdeledCube(width: UIScreen.main.bounds.width/2.6, height: UIScreen.main.bounds.height/7)
                    ModdeledTestCube()
                Button {
                    showFinalCube = false
                } label: {
                    Text("Go Back")
                }
            }
            
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        SolvingView()
            .environmentObject(PhotoCaptureView())
            .environmentObject(GridVitals())
        
    }
}
