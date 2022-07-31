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
    @Published var photoName: String?
    @Published var photoDescription: String?
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPhotos")
    
    var exampleImage = UIImage(systemName: "example6")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            photoList = try JSONDecoder().decode([Photo].self, from: data)
        } catch {
            photoList = []
        }
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
    
    func addPhoto() {
//        if let jpegData = exampleImage!.jpegData(compressionQuality: 0.8) {
//            try? jpegData.write(to: savePath, options: [.atomic, .completeFileProtection])
//        }
        
        guard let jpegData = exampleImage!.jpegData(compressionQuality: 0.8) else {
            print("image compression error")
            return
        }
        
        let newPhoto = Photo(id: UUID(), name: "New location", description: "", photoData: jpegData)
        photoList.append(newPhoto)
        save()
    }
    
    func updatePhoto(photo: Photo) {
        guard let updatePhoto = updatePhoto else {
            return
        }
        
        let index = photoList.first { $0.id == updatePhoto.id }
        guard index != nil else {
            return
        }
        
        if let index = photoList.firstIndex(of: updatePhoto) {
            photoList[index] = photo
            save()
        }
    }
}
