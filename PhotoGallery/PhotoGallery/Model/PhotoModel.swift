//
//  PhotoModel.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 31.07.22.
//

import Foundation


struct Photo: Identifiable, Codable, Equatable, Comparable {
    var id: UUID
    var name: String
    var description: String?
    var photoData: Data
    
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: Photo, rhs: Photo) -> Bool {
        lhs.name < rhs.name
    }
}
