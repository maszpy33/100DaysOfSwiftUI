//
//  PhotoViewModel.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 31.07.22.
//

import Foundation
import UIKit
import MapKit



@MainActor class PhotoViewModel: ObservableObject {
    
    let examplePhotos = ["example1", "example2", "example3", "example4", "example5", "example6", "example7", "example8"]
    
    @Published var photoList: [Photo]
    @Published var sortetdPhotoList: [Photo] = []
    @Published var selectedPhoto: UIImage?
    @Published var updatePhoto: Photo?
    @Published var photoName: String = ""
    @Published var photoDescription: String?
    @Published var latitude: Double = 50.77
    @Published var longitude: Double = 6.1

    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.77, longitude: 6.1), span: MKCoordinateSpan(latitudeDelta: 11, longitudeDelta: 11))

    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPhotos")
    
    let exampleImage = UIImage(systemName: "example6")
    
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            photoList = try JSONDecoder().decode([Photo].self, from: data)
        } catch {
            photoList = []
        }
    }
    
    // HELPER FUNCTION
    func addExamples() {
        let randomPhoto = UIImage(named: "example\(Int.random(in: 1...6))")
        
        guard let jpegData = randomPhoto?.jpegData(compressionQuality: 0.8) else {
            print("image compression error")
            return
        }
        
        let randLat = Double.random(in: 5.0...7.0)
        let roundLati = round(randLat * 100) / 100.0
        
        let randLongi = Double.random(in: 50.0...52.0)
        let roundLongi = round(randLongi * 100) / 100.0
        
        print("Random Longitude: \(roundLongi)")
        print("Random Latitude: \(roundLati)")

        
        let newPhoto = Photo(id: UUID(), name: "GoLang Scientist", description: "Mascot of the programming language Go", photoData: jpegData, latitude: roundLati, longitude: roundLongi)
        
        photoList.append(newPhoto)
//        photoList.insert(newPhoto, at: 0)
        sortetdPhotoList = photoList.sorted(by: { $0.name < $1.name })
        save()
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(photoList)
            // .completeFileProtection encryptes the data
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
    
    func addPhoto(photo: UIImage, name: String, description: String?, currentLatitude: Double, currentLongitude: Double) {
        // compress image with quality 0.8
        guard let jpegData = photo.jpegData(compressionQuality: 0.8) else {
            print("image compression error")
            return
        }
        
        let newPhoto = Photo(id: UUID(), name: photoName, description: photoDescription, photoData: jpegData, latitude: currentLatitude, longitude: currentLongitude)
        
        // remove append and save from function so user has to name the photo first, before it is saved
//        photoList.append(newPhoto)
//        photoList.insert(newPhoto, at: 0)
        photoList.append(newPhoto)
        sortetdPhotoList = photoList.sorted(by: { $0.name < $1.name })
        
        save()
    }
    
    func deletePhoto(photo: Photo) {
        if let index = photoList.firstIndex(where: { $0.id == photo.id }) {
            print("remove photo with name \(photoList[index].name)")
            photoList.remove(at: index)
            sortetdPhotoList = photoList.sorted(by: { $0.name < $1.name })
            save()
        }
    }
    
    func deleteAllContent() {
        sortetdPhotoList = []
        photoList = []
        save()
    }
    
    func updatePhoto(photo: Photo) {
        // check if photo is nil or corrupted
        guard let updatePhoto = updatePhoto else {
            return
        }
        
        let index = photoList.first { $0.id == updatePhoto.id }
        guard index != nil else {
            print("photo not found")
            return
        }
        
        if let index = photoList.firstIndex(of: updatePhoto) {
            
            photoList[index].name = photoName
            photoList[index].description = photoDescription
            sortetdPhotoList = photoList.sorted(by: { $0.name < $1.name })
            
            save()
        }
    }
}
