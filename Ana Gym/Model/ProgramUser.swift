//
//  ProgramUser.swift
//  Ana Gym
//
//  Created by Esslam Emad on 13/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct ProgramUser: Codable, JSONSerializable{
    
    var programID: Int!
    var userID: Int!
    var active: Int!
    
    enum CodingKeys: String, CodingKey{
        case programID = "program_id"
        case userID = "user_id"
        case active
    }
}
