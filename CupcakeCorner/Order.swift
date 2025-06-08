//
//  Order.swift
//  CupcakeCorner
//
//  Created by HiRO on 08/06/25.
//

import Foundation

@Observable
class Order {
    static let types: [String] = ["Vanilla", "Chocolate", "Strawberry", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
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
        name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty ? false : true
    }
}
