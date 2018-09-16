//
//  SubscribedProgram.swift
//  Ana Gym
//
//  Created by Esslam Emad on 29/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct SubscribedProgram: Codable{
    var programID: Int!
    var userID: Int!
    var programName: String!
    var userName: String!
    var userUsername: String!
    
    enum CodingKeys: String, CodingKey{
        case programID = "program_id"
        case userID = "user_id"
        case programName = "program_name"
        case userName = "user_name"
        case userUsername = "user_username"
    }
}
