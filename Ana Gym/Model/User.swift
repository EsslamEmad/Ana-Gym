//
//  User.swift
//  Ana Gym
//
//  Created by Esslam Emad on 13/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation


struct User: Codable, JSONSerializable{
    
    var id: Int!
    var username: String!
    var name: String!
    var email: String!
    var password: String!
    var phone: String!
    var weight: Int!
    var height: Int!
    var gender: Int!
    var hearUs: String!
    var token: String!
    var programID: Int!
    var status: Int!
    var method: Int?
    var uploadPhoto: String?
    
    enum CodingKeys: String, CodingKey{
        case id
        case username
        case name
        case email
        case password
        case phone
        case weight
        case height
        case gender
        case hearUs = "hear_us"
        case token
        case programID = "program_id"
        case status
        case method
        case uploadPhoto = "image"
    }
}
