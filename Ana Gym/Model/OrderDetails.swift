//
//  OrderDetails.swift
//  Ana Gym
//
//  Created by Esslam Emad on 13/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct OrderDetails: Codable, JSONSerializable{
    
    var productName: String!
    var price: Double!
    var quantity: Int!
    var flavor: Int!
    var quantityDesc: Int!
    var priceQTY: Double!
    var photo: String?
    
    enum CodingKeys: String, CodingKey{
        case productName = "product_name"
        case price
        case quantity
        case flavor
        case quantityDesc = "quantity_desc"
        case priceQTY = "price_qty"
        case photo
    }
}
