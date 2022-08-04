//
//  ContentView.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 31.07.22.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var photoVM = PhotoViewModel()
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    @State private var showAddView = false
    @State var showEditView = false
    
//    @State var name: String = ""
//    @State var description: String = ""
    
    @State private var showAlert: Bool = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                ZStack {
                    VStack {
                        if image != nil {
                            HStack {
                                Text("Last added: ")
                                image?
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(.gray, lineWidth: 3)
                                    )
                                    .frame(width: 80, height: 80)
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
                            
//                            VStack {
//                                Button {
//                                    photoVM.save()
//                                } label: {
//                                    Image(systemName: "s.circle")
//                                        .padding()
//                                        .background(.black.opacity(0.75))
//                                        .foregroundColor(.green)
//                                        .font(.title)
//                                        .clipShape(Circle())
//                                        .overlay(
//                                            Circle()
//                                                .stroke(.green, lineWidth: 1)
//                                        )
//                                        .padding(.horizontal, 15)
//                                }
//                                Text("Save Examples")
//                                    .font(.system(size: 12, weight: .light))
//                            }
                            
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
                .navigationTitle("Photo Gallary")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $inputImage)
                }
                .onChange(of: inputImage) { _ in loadImage() }
//                .sheet(isPresented: $showAddView, onDismiss: {
//                    print("dismiss EditView")
//    //                 check if photoList is not empty -> would throw an error
//                    if !photoVM.photoList.isEmpty {
//                        if photoVM.photoName == "" {
//    //                        photoVM.deletePhoto(photo: photoVM.photoList.first!)
//
//                            // check again if photoList is now empty
//                            // if its empty mage last added image preview nil
//                            if photoVM.photoList.isEmpty {
//                                image = nil
//                            } else {
//                                print("List Count: \(photoVM.photoList.count)")
//                                image = Image(uiImage: UIImage(data: photoVM.photoList.first!.photoData) ?? UIImage(systemName: "questionmark")!)
//                            }
//                        } else {
//                            photoVM.save()
//                        }
//                    } else {
//                        image = nil
//                    }
//
//                    photoVM.photoName = ""
//                    photoVM.photoDescription = ""
//                }) {
//                    AddView()
//                        .environmentObject(photoVM)
//                }
                .onAppear {
    //                 check if photoList is not empty -> would throw an error
                    if !photoVM.photoList.isEmpty {
                        if photoVM.photoName == "" {
    //                        photoVM.deletePhoto(photo: photoVM.photoList.first!)
    
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
    //            .onAppear {
    //                photoVM.save()
    //            }
                
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
