//
//  ImagePicker.swift
//  Instafilter
//
//  Created by Andreas Zwikirsch on 27.04.22.
//

import PhotosUI
import SwiftUI


struct ImagePicker: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
