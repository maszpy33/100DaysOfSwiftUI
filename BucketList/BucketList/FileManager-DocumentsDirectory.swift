//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Andreas Zwikirsch on 26.07.22.
//

import Foundation


extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
