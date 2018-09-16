//
//  Category.swift
//  Ana Gym
//
//  Created by Esslam Emad on 13/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct Category: Codable, JSONSerializable{
    var id: Int!
    var title: String!
    
    enum CodingKeys: String, CodingKey{
        case id
        case title
    }
}
