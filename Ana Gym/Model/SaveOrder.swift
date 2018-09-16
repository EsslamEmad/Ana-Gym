//
//  SaveOrder.swift
//  Ana Gym
//
//  Created by Esslam Emad on 13/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct SaveOrder: Codable, JSONSerializable{
    
    var userID: Int!
    var pay: Int!
    var currency: String!
    var cart: [CartItem]!
    enum CodingKeys: String, CodingKey{
        case userID = "user_id"
        case pay
        case currency
        case cart
    }
}

struct CartItem: Codable, JSONSerializable{
    var productID: Int!
    var quantity: Int!
    enum CodingKeys: String, CodingKey{
        case productID = "product_id"
        case quantity
    }
}
