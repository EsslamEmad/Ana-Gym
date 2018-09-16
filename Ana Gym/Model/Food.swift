//
//  Food.swift
//  Ana Gym
//
//  Created by Esslam Emad on 5/9/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct Food: Codable, JSONSerializable{
    var id: Int!
    var name: String!
    var details: String!
    var video: String?
    var videoThumb: String?
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case details
        case video = "vedio"
        case videoThumb = "video_thumb"
    }
}
