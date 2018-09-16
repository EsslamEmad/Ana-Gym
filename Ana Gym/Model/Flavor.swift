//
//  Flavor.swift
//  Ana Gym
//
//  Created by Esslam Emad on 13/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct Flavor: Codable, JSONSerializable{
    var id: String!
    var name: String!
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
    }
}
