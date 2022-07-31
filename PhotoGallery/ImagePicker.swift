//
//  ImagePicker.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 31.07.22.
//

import PhotosUI
import SwiftUI


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    // nested class, could also be initialized outside of the struct
    class Coordinator: NSObject, PHPickerViewControllerDelegate  {
        // parant is the binding image of the struct ImagePicker
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // required function, do not delete
    }
    
    func makeCoordinator() -> Coordinator {
        // struct ImagePicker passes itself to the instans of the class Coordinator
        Coordinator(self)
    }
}
