//
//  UploadResponse.swift
//  Ana Gym
//
//  Created by Esslam Emad on 5/9/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct UploadResponse: Codable{
    
    var image: String!
    var thumb: String!
    
    enum CodingKeys: String, CodingKey{
        case image
        case thumb
    }
}
