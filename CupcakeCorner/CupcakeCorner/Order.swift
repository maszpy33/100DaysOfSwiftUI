//
//  NewOrder.swift
//  CupcakeCorner
//
//  Created by Andreas Zwikirsch on 25.11.21.
//

import Foundation

enum CodingKeys: CodingKey {
    case type
    case quantity
    case extraFrosting
    case addSprinkles
    case name
    case streetAddress
    case city
    case zip
}

// Challenge 3
class ObservableOrder: ObservableObject {
    @Published var order: Order
    
    init(order: Order) {
        self.order = order
    }
}

// Challenge 3
struct Order: Codable {
    
// ?? Is there a differe between the use of enum as onliner or like above and if I use
// ?? it inside my class or outside as global?
//    enum CodingKeys: CodingKey {
//        case type, quantity, extraFrosting, addSprinkles, name, streetAdress, city, zip
//    }
    
    static let types = ["Vanilla", "Strawberry", "Chocoloate", "Rainbow", "Salted Caramel", "Peanut Butter"]
    
    var type = 0
    var quantity = 3
    
    var specialReqestEnabled = false {
        didSet {
            if specialReqestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        
        // Challenge 1
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        
        if streetAddress.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        
        if city.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        
        if zip.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        
        return true
    }
    
    var cost: Double {
        // 2€ per cake
        var cost = Double(quantity) * 2
        
        // complicated cakes cost more
        cost += (Double(type) / 2)
        
        // 1€/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        
        // 0.50€/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
}
