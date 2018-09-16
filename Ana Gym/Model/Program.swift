//
//  Program.swift
//  Ana Gym
//
//  Created by Esslam Emad on 13/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation

struct Program: Codable, JSONSerializable{
    var id: Int!
    var price: Double!
    var priceDollar: Double!
    var name: String!
    var coach: String!
    var subtitle: String!
    var details: String!
    var mainVideo: String!
    var trainingVideo: String!
    var nutritionVideo: String!
    var mainVideoThumb: String?
    var trainingVideoThumb: String?
    var nutritionVideoThumb: String?
    var photo: String!
    var training: [Flavor]?
    var nutritionMale: [Flavor]?
    var nutritionFemale: [Flavor]?
    var nutrition: [Flavor]?
    var breakfast: [Flavor]?
    var snacks: [Flavor]?
    var lunchDinner: [Flavor]?
    var subscribtionState: String!
    
    enum CodingKeys: String, CodingKey{
        case id
        case price
        case priceDollar = "price_dollar"
        case name
        case coach
        case subtitle
        case details
        case mainVideo = "main_vedio"
        case trainingVideo = "training_vedio"
        case nutritionVideo = "nutrition_vedio"
        case photo
        case mainVideoThumb = "main_vedio_thumb"
        case trainingVideoThumb = "training_vedio_thumb"
        case nutritionVideoThumb = "nutrition_vedio_thumb"
        case training
        case nutritionMale = "nutrition_male"
        case nutritionFemale = "nutrition_female"
        case nutrition
        case breakfast
        case snacks
        case lunchDinner = "lunch_dinner"
        case subscribtionState = "subscription_state"
    }
    
}
