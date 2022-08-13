//
//  MapView.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 06.08.22.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var photoVM: PhotoViewModel
    
//    @Binding var toggleMiniMap: Bool
    let someBool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                //                Map(coordinateRegion: $photoVM.mapRegion, showsUserLocation: true, userTrackingMode: .constant(.follow))
                //                            .frame(width: 400, height: 300)
                if someBool {
                    Map(coordinateRegion: $photoVM.mapRegion, showsUserLocation: true, userTrackingMode: .constant(.follow))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray, lineWidth: 3)
                        )
                        .ignoresSafeArea()
                } else {
                    Map(coordinateRegion: $photoVM.mapRegion,  interactionModes: .all, showsUserLocation: true, annotationItems: photoVM.photoList) { photo in
                        MapAnnotation(coordinate: photo.coordinate) {
                            VStack {
                                Image(systemName: "mappin")
                                    .resizable()
                                    .foregroundColor(.red)
                                    .frame(width: 10, height: 25)
//                                    .background(.white)
//                                    .clipShape(Circle())
                                Text(photo.name)
                                    .fixedSize()
                            }
                        }
                    }
                    .ignoresSafeArea()
                }

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

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
