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
                ScrollView {
                    LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                        ForEach(photoVM.sortetdPhotoList, id: \.self) { photo in
                            NavigationLink(destination: EditView(photo: photo), label: {
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
                //                ScrollView {
                //                    LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                //                        ForEach(photoVM.sortetdPhotoList) { photo in
                //                            VStack {
                //                                Image(uiImage: UIImage(data: photo.photoData) ?? UIImage(systemName: "questionmark")!)
                //                                    .resizable()
                //                                    .scaledToFit()
                //                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                //                                    .overlay(
                //                                        RoundedRectangle(cornerRadius: 16)
                //                                            .stroke(.gray, lineWidth: 3)
                //                                    )
                //                                Text(photo.name)
                //                                    .font(.subheadline)
                //                            }
                //                            .padding(8)
                //                            .onTapGesture {
                //                                photoVM.updatePhoto = photo
                //                                showEditView = true
                //                            }
                //                        }
                //                    }
                //                }
//            .sheet(isPresented: $showEditView) {
//                EditView(photo: photoVM.updatePhoto!)
//            }
        }
    }
}

struct PhotoGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGalleryView()
    }
}
