//
//  ContentView.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 31.07.22.
//

import SwiftUI
import MapKit
import CoreLocation


struct ContentView: View {
    
    @StateObject var photoVM = PhotoViewModel()
    let locationFetcher = LocationFetcher()
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    @State private var showAddView = false
    @State var showEditView = false
    
    @State private var showAlert: Bool = false
    
    @State private var currentLatitude: Double = 0.0
    @State private var currentLongitude: Double = 0.0
    
    @State var showMapView: Bool = false
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    
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
                                            .font(.title2)
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
                                            .frame(width: 150, height: 150)
                                            .padding(.leading)
                                            .padding(.trailing, 15)
                                    }
                                    
                                    VStack {
                                        Text("Latitude: \(currentLatitude)")
                                            .font(.subheadline)
                                        Text("Longitude: \(currentLongitude)")
                                            .font(.subheadline)
                                        Text("Show Map")
                                        NavigationLink(destination:
                                                        MapView()
                                            .environmentObject(photoVM)
                                        ) {
                                            Image(systemName: "map.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .padding(10)
                                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(.gray, lineWidth: 3)
                                                )
                                                .frame(width: 60, height: 60)
                                                .padding(.top, 10)
                                                .foregroundColor(.orange)
                                        }
                                    }
                                }
                            }
                        }
                        
                        ScrollView {
                            LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                                ForEach(photoVM.sortetdPhotoList, id: \.self) { photo in
                                    NavigationLink(destination:
                                                    EditView(photo: photo)
                                        .environmentObject(photoVM)
                                                   
                                                   , label: {
                                        VStack {
                                            Image(uiImage: UIImage(data: photo.photoData) ?? UIImage(systemName: "questionmark")!)
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(.gray, lineWidth: 3)
                                                )
                                            Text(photo.name)
                                                .font(.subheadline)

                                        }
                                    })
                                    .padding(8)
                                    .onTapGesture {
                                        photoVM.updatePhoto = photo
                                        showEditView = true
                                    }
                                }
                            }
                        }
//                        PhotoGalleryView()
//                            .environmentObject(photoVM)
                    }
                    
                    // BUTTON SECTION (could be in a seperated view for a cleaner ContentView
                    VStack {
                        Spacer()
                        HStack {
                            
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
                                    self.locationFetcher.start()
                                    if let location = self.locationFetcher.lastKnownLocation {
                                        photoVM.latitude = location.latitude
                                        photoVM.longitude = location.longitude
                                        print("___________________________")
                                        print("Latitude \(photoVM.latitude)")
                                        print("Longitude \(photoVM.longitude)")
                                        print("___________________________")
                                    } else {
                                        print("___________________________")
                                        print("Location detection error")
                                        print("___________________________")
                                    }
                                    
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
                            
                            VStack {
                                Button {
                                    print("Current Location")
                                    
                                    locationFetcher.start()
                                    
                                    if let location = self.locationFetcher.lastKnownLocation {
                                        photoVM.latitude = location.latitude
                                        photoVM.longitude = location.longitude
                                        currentLatitude = location.latitude
                                        currentLongitude = location.longitude
                                        print("___________________________")
                                        print("Your location is \(location)")
                                        print("Latitude \(photoVM.latitude)")
                                        print("Longitude \(photoVM.longitude)")
                                        print("___________________________")
                                    } else {
                                        print("___________________________")
                                        print("Your location is unknown")
                                        print("___________________________")
                                    }
                                    
                                } label: {
                                    Image(systemName: "mappin.and.ellipse")
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
                                Text("Print Location")
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
                    AddView(locationFetcher: locationFetcher, showAddView: $showAddView)
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
