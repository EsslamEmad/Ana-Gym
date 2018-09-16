//
//  Video.swift
//  Ana Gym
//
//  Created by Esslam Emad on 1/9/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct Video: Codable, JSONSerializable{
    var name: String?
    var url: String!
    var thumb: String?
    
    enum CodingKeys: String, CodingKey{
        case name
        case url
        case thumb
    }
}
