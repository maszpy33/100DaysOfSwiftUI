//
//  PhotoModel.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 31.07.22.
//

import Foundation
import MapKit


struct Photo: Identifiable, Codable, Equatable, Comparable, Hashable {
    var id: UUID
    var name: String
    var description: String?
    var photoData: Data
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: Photo, rhs: Photo) -> Bool {
        lhs.name < rhs.name
    }
}
