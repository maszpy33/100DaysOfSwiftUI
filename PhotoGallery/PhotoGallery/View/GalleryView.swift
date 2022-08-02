//
//  PhotoGalleryView.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 31.07.22.
//

import SwiftUI

struct PhotoGalleryView: View {
    
    @EnvironmentObject var photoVM: PhotoViewModel
    
    @State private var showEditView = false
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                        ForEach(photoVM.photoList) { photo in
                            VStack {
                                Image(uiImage: UIImage(data: photo.photoData) ?? UIImage(systemName: "questionmark")!)
                                    .resizable()
                                    .scaledToFit()
                                Text(photo.name)
                                    .font(.subheadline)
                            }
                            .padding(8)
                            .onTapGesture {
//                                showEditView = true
                                print(photo.name)
                                photoVM.updatePhoto = photo
                                showEditView = true
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showEditView) {
                EditView(photo: photoVM.updatePhoto!)
            }
        }
    }
}

struct PhotoGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGalleryView()
    }
}
