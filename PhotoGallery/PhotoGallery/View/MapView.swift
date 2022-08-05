//
//  MapView.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 06.08.22.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var photoVM: PhotoViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                //                Map(coordinateRegion: $photoVM.mapRegion, showsUserLocation: true, userTrackingMode: .constant(.follow))
                //                            .frame(width: 400, height: 300)
                Map(coordinateRegion: $photoVM.mapRegion, annotationItems: photoVM.photoList) { photo in
                    MapAnnotation(coordinate: photo.coordinate) {
                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(Circle())
                            Text(photo.name)
                                .fixedSize()
                        }
                        .onTapGesture {
                            photoVM.updatePhoto = photo
                        }
                    }
                }
                .ignoresSafeArea()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primary)
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
