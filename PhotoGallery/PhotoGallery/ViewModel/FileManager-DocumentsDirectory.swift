//
//  FileManager-DocumentsDirectory.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 31.07.22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
