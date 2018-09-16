//
//  Order.swift
//  Ana Gym
//
//  Created by Esslam Emad on 13/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct Order: Codable, JSONSerializable{
    
    var id: Int!
    var date: Date!
    var userID: Int!
    var state: Int!
    var total: Double!
    var currency: String!
    var pay: Int!
    var payConfirmation: Bool!
    var orderReturnReason: String?
    
    enum CodingKeys: String, CodingKey{
        case id = "order_id"
        case date = "order_date"
        case userID = "user_id"
        case state
        case total
        case currency
        case pay
        case payConfirmation = "pay_confirm"
        case orderReturnReason = "return_order_reason"
    }
}
