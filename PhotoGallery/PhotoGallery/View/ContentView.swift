//
//  ContentView.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 31.07.22.
//

import SwiftUI
import MapKit


struct ContentView: View {
    
    @StateObject var photoVM = PhotoViewModel()
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    @State private var showAddView = false
    @State var showEditView = false
    
    @State private var showAlert: Bool = false
    
    @State private var toggleMiniMap: Bool = false
    
    @State var showMapView: Bool = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                ZStack {
                    VStack {
                        HStack {
                            if image != nil {
                                HStack {
                                    VStack {
                                        Text("Last added: ")
                                            .padding(.leading)
                                            .padding(.trailing, 15)
                                        image?
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(.gray, lineWidth: 3)
                                            )
                                            .frame(width: 100, height: 100)
                                            .padding(.leading)
                                            .padding(.trailing, 15)
                                    }
                                    
                                    HStack {
                                        if toggleMiniMap {
                                            VStack {
                                                Text("Location")
                                                Map(coordinateRegion: $photoVM.mapRegion, showsUserLocation: true, userTrackingMode: .constant(.follow))
                                                    .frame(width: 100, height: 100)
                                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 16)
                                                            .stroke(.gray, lineWidth: 3)
                                                    )
                                                    .onTapGesture {
                                                        showMapView = true
                                                    }
                                            }
                                        } else {
                                            VStack {
                                                Text("Location")
                                                MapView()
                                                    .environmentObject(photoVM)
                                                    .frame(width: 100, height: 100)
                                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 16)
                                                            .stroke(.gray, lineWidth: 3)
                                                    )
                                                    .onTapGesture {
                                                        showMapView = true
                                                    }
                                            }
                                        }
                                    }
                                    .sheet(isPresented: $showMapView) {
                                        MapView()
                                            .environmentObject(photoVM)
                                    }
                                    
                                    VStack {
                                        Image(systemName: "location.fill.viewfinder")
                                            .foregroundColor(toggleMiniMap ? .blue : .gray)
                                            .padding(.vertical)
                                        //                                            Text(" - ")
                                        Image(systemName: "photo")
                                            .foregroundColor(toggleMiniMap ? .gray : .blue)
                                            .padding(.vertical)
                                    }
                                    .onTapGesture {
                                        toggleMiniMap.toggle()
                                    }
                                }
                            }
                        }
                        
                        PhotoGalleryView()
                            .environmentObject(photoVM)
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            //                            Spacer()
                            
                            VStack {
                                Button {
                                    showAlert = true
                                } label: {
                                    Image(systemName: "trash")
                                        .padding()
                                        .background(.black.opacity(0.75))
                                        .foregroundColor(.red)
                                        .font(.title)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(.red, lineWidth: 1)
                                        )
                                        .padding(.horizontal, 15)
                                }
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("⚠️ Caution ⚠️"),
                                        message: Text("Delete all content?"),
                                        primaryButton: .destructive(Text("Delete All")) {
                                            photoVM.deleteAllContent()
                                            image = nil
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                                
                                Text("Delete All")
                                    .font(.system(size: 12, weight: .light))
                            }
                            
                            VStack {
                                Button {
                                    photoVM.addExamples()
                                    if photoVM.photoList.count > 0 {
                                        image = Image(uiImage: UIImage(data: photoVM.photoList.first!.photoData)!)
                                    }
                                } label: {
                                    Image(systemName: "doc.badge.plus")
                                        .padding()
                                        .background(.black.opacity(0.75))
                                        .foregroundColor(.white)
                                        .font(.title)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(.white, lineWidth: 1)
                                        )
                                        .padding(.horizontal, 15)
                                }
                                Text("Add Example")
                                    .font(.system(size: 12, weight: .light))
                            }
                            
                            VStack {
                                Button {
                                    showingImagePicker = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        showAddView = true
                                    }
                                    
                                } label: {
                                    Image(systemName: "plus")
                                        .padding()
                                        .background(.black.opacity(0.75))
                                        .foregroundColor(.white)
                                        .font(.title)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(.white, lineWidth: 1)
                                        )
                                        .padding(.horizontal, 15)
                                }
                                Text("Add Photo")
                                    .font(.system(size: 12, weight: .light))
                            }
                        }
                    }
                }
                .navigationTitle("Welcome to PhotoGal")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $inputImage)
                }
                .onChange(of: inputImage) { _ in loadImage() }
                .onAppear {
                    //                    check if photoList is not empty -> would throw an error
                    if !photoVM.photoList.isEmpty {
                        if photoVM.photoName == "" {
                            //                            photoVM.deletePhoto(photo: photoVM.photoList.first!)
                            
                            // check again if photoList is now empty
                            // if its empty mage last added image preview nil
                            if photoVM.photoList.isEmpty {
                                image = nil
                            } else {
                                print("List Count: \(photoVM.photoList.count)")
                                image = Image(uiImage: UIImage(data: photoVM.photoList.first!.photoData) ?? UIImage(systemName: "questionmark")!)
                            }
                        } else {
                            photoVM.save()
                        }
                    } else {
                        image = nil
                    }
                    
                    photoVM.photoName = ""
                    photoVM.photoDescription = ""
                }
                
                if showAddView {
                    AddView(showAddView: $showAddView)
                        .environmentObject(photoVM)
                }
            }
        }
        .onAppear {
            photoVM.sortetdPhotoList = photoVM.photoList
        }
    }
    
    // helper function to convert UIImage to Image and save it
    func loadImage() {
        guard let inputImage = inputImage else { return }
        photoVM.selectedPhoto = inputImage
        image = Image(uiImage: inputImage)
        
        // show EditView, so user has to name the imported photo
        showEditView = true
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
