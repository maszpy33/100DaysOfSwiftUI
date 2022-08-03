//
//  PhotoViewModel.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 31.07.22.
//

import Foundation
import UIKit



@MainActor class PhotoViewModel: ObservableObject {
    
    let examplePhotos = ["example1", "example2", "example3", "example4", "example5", "example6", "example7", "example8"]
    
    @Published var photoList: [Photo]
    @Published var selectedPhoto: UIImage?
    @Published var updatePhoto: Photo?
    @Published var photoName: String = ""
    @Published var photoDescription: String?
    
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
        
        let newPhoto = Photo(id: UUID(), name: "GoLang Scientist", description: "Mascot of the programming language Go", photoData: jpegData)
        
//        photoList.append(newPhoto)
        photoList.insert(newPhoto, at: 0)
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
    
    func addPhoto(photo: UIImage, name: String, description: String?) {
        // compress image with quality 0.8
        guard let jpegData = photo.jpegData(compressionQuality: 0.8) else {
            print("image compression error")
            return
        }
        
        let newPhoto = Photo(id: UUID(), name: photoName, description: photoDescription, photoData: jpegData)
        
        // remove append and save from function so user has to name the photo first, before it is saved
//        photoList.append(newPhoto)
        photoList.insert(newPhoto, at: 0)
        save()
    }
    
    func deletePhoto(photo: Photo) {
        if let index = photoList.firstIndex(where: { $0.id == photo.id }) {
            photoList.remove(at: index)
            save()
        }
    }
    
    func deleteAllContent() {
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
            save()
        }
    }
}
