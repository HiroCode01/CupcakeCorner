//
//  Order.swift
//  CupcakeCorner
//
//  Created by HiRO on 08/06/25.
//

import Foundation

@Observable
class Order: Codable {
    private let userDefaultsAddressKey = "UserAddress"
    
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
    }

    
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
    
    var name = "" {
        didSet {
            saveAddress()
        }
    }
    var streetAddress = "" {
        didSet {
            saveAddress()
        }
    }
    var city = "" {
        didSet {
            saveAddress()
        }
    }
    var zip = "" {
        didSet {
            saveAddress()
        }
    }
    
    var hasValidAddress: Bool {
        name.isEmpty || name.hasPrefix(" ") || streetAddress.isEmpty || streetAddress.hasPrefix(" ") || city.isEmpty || city.hasPrefix(" ") || zip.isEmpty || zip.hasPrefix(" ") ? false : true
    }
    
    var cost: Decimal {
        var cost = Decimal(quantity) * 2
        cost += Decimal(type) / 2
        
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
    
    func saveAddress() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsAddressKey)
        }
    }
    
    init() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsAddressKey),
           let decoded = try? JSONDecoder().decode(Order.self, from: savedData) {
            self.name = decoded.name
            self.streetAddress = decoded.streetAddress
            self.city = decoded.city
            self.zip = decoded.zip
        }
    }
}
