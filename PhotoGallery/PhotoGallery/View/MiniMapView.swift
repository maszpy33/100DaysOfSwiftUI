//
//  MiniMapView.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 07.08.22.
//

import SwiftUI
import MapKit
import CoreLocation

struct MiniMapView: View {
    
    @EnvironmentObject var photoVM: PhotoViewModel
    
    @Binding var toggleMiniMap: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                //                Map(coordinateRegion: $photoVM.mapRegion, showsUserLocation: true, userTrackingMode: .constant(.follow))
                //                            .frame(width: 400, height: 300)
                if toggleMiniMap {
                    Map(coordinateRegion: $photoVM.mapRegion, showsUserLocation: true, userTrackingMode: .constant(.follow))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray, lineWidth: 3)
                        )
                        .ignoresSafeArea()
                } else {
                    Map(coordinateRegion: $photoVM.mapRegion, annotationItems: photoVM.photoList) { photo in
                        MapAnnotation(coordinate: photo.coordinate) {
                            VStack {
                                Image(systemName: "mappin")
                                    .resizable()
                                    .foregroundColor(.red)
                                    .frame(width: 5, height: 20)
//                                    .background(.white)
//                                    .clipShape(Circle())
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
            }
        }
    }
}

//struct MiniMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MiniMapView()
//    }
//}
