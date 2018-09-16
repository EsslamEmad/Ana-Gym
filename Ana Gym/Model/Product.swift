//
//  Product.swift
//  Ana Gym
//
//  Created by Esslam Emad on 13/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct Product: Codable, JSONSerializable{
    
    var id: Int!
    var categoryID: Int!
    var name: String!
    var details: String!
    var photos: [String]!
    var price: Double!
    var priceDollar: Double!
    var quantity: Int!
    
    enum CodingKeys: String, CodingKey{
        case id
        case categoryID = "category"
        case name
        case details
        case photos
        case price
        case priceDollar = "price_dollar"
        case quantity
    }
}
