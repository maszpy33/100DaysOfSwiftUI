//
//  PhotoGalleryView.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 31.07.22.
//

import SwiftUI

struct PhotoGalleryView: View {
    
    @EnvironmentObject var photoVM: PhotoViewModel
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                        ForEach(photoVM.examplePhotos, id: \.self) { photo in
                            Image(photo)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
            }
        }
    }
}

struct PhotoGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGalleryView()
    }
}
