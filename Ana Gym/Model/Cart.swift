//
//  Cart.swift
//  Ana Gym
//
//  Created by Esslam Emad on 13/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct Cart: Codable, JSONSerializable{
    
    var productID: Int!
    var price: Double!
    var qty: Int?
    var quantity: Int!
    var flavor: Int?
    var priceQTY: Double?
    var userID: Int!
    var photo: String?
    
    enum CodingKeys: String, CodingKey{
        case productID = "product_id"
        case price
        case qty
        case quantity
        case flavor
        case priceQTY = "price_qty"
        case userID = "user_id"
        case photo
    }
}
