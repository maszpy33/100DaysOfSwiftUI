//
//  ImageSaver.swift
//  Instafilter
//
//  Created by Andreas Zwikirsch on 28.04.22.
//

import UIKit

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, context: UnsafeRawPointer) {
        print("Save finished!")
    }
    
}
