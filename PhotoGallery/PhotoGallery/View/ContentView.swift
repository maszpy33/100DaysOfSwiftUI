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
    @State private var showEditView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    PhotoGalleryView()
                        .environmentObject(photoVM)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            showEditView = true
                        } label: {
                            Image(systemName: "pencil")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding()
                        }
                        
                        Button {
                            showingImagePicker = true
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding()
                        }
                    }
                }
            }
            .navigationTitle("Photo Gallery")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .sheet(isPresented: $showEditView) {
                PhotoEditView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
