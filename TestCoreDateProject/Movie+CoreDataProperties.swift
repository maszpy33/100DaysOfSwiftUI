//
//  Movie+CoreDataProperties.swift
//  TestCoreDateProject
//
//  Created by Andreas Zwikirsch on 10.12.21.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String?
    @NSManaged public var director: String?
    @NSManaged public var year: Int16
    
    public var wrappedTitle: String {
        title ?? "Unknowen Title"
    }

}

extension Movie : Identifiable {

}
