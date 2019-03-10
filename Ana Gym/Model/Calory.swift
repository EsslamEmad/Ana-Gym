//
//  Calory.swift
//  Ana Gym
//
//  Created by Esslam Emad on 5/9/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct Calory: Codable, JSONSerializable{
    var id: Int!
    var name: String!
    var details: String!
    var video: String?
    var videoThumb: String?
    var file: String?
    var photos: [String]?
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case details
        case video = "vedio"
        case videoThumb = "video_thumb"
        case file
        case photos
    }
}
