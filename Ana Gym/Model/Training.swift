//
//  Training.swift
//  Ana Gym
//
//  Created by Esslam Emad on 13/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct Training: Codable, JSONSerializable{
    
    var id: Int!
    var programID: Int!
    var offDay: Int!
    var dayName: String!
    var name: String!
    var details: String!
    var videos: [Video]!
    /*var video1Name: String!
    var video1URL: String!
    var video2Name: String? = ""
    var video2URL: String? = ""
    var video3Name: String? = ""
    var video3URL: String? = ""
    var video4Name: String? = ""
    var video4URL: String? = ""
    var video5Name: String? = ""
    var video5URL: String? = ""
    var video6Name: String? = ""
    var video6URL: String? = ""
    var video7Name: String? = ""
    var video7URL: String? = ""
    var video8Name: String? = ""
    var video8URL: String? = ""*/
    
    enum CodingKeys: String, CodingKey{
        case id
        case programID = "program_id"
        case offDay = "off_day"
        case dayName = "day_name"
        case name
        case details
        case videos
        /*case video1Name = "vedio1_name"
        case video1URL =  "vedio1_url"
        case video2Name = "vedio2_name"
        case video2URL = "vedio2_url"
        case video3Name = "vedio3_name"
        case video3URL = "vedio3_url"
        case video4Name = "vedio4_name"
        case video4URL = "vedio4_url"
        case video5Name = "vedio5_name"
        case video5URL = "vedio5_url"
        case video6Name = "vedio6_name"
        case video6URL = "vedio6_url"
        case video7Name = "vedio7_name"
        case video7URL = "vedio7_url"
        case video8Name = "vedio8_name"
        case video8URL = "vedio8_url"*/
    }
}
