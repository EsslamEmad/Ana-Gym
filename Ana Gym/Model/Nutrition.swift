//
//  Nutrition.swift
//  Ana Gym
//
//  Created by Esslam Emad on 13/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct Nutrition: Codable, JSONSerializable{
    
    var id: Int!
    var programID: Int!
    var name: String!
    var details: String!
    var file: String?
    var photos: [String]?
    
    enum CodingKeys: String, CodingKey{
        case id
        case programID = "program_id"
        case name
        case details
    }
}
