//
//  Singer+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Andreas Zwikirsch on 06.12.21.
//
//

import Foundation
import CoreData


extension Singer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Singer> {
        return NSFetchRequest<Singer>(entityName: "Singer")
    }

    @NSManaged public var lastName: String?
    @NSManaged public var firstName: String?
    
    var wrappedFirstName: String {
        firstName ?? "Unknowen"
    }
    
    var wrappedLastName: String {
        lastName ?? "Unknowen"
    }
}

extension Singer : Identifiable {

}
