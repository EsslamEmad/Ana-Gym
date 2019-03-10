//
//  APIRequests.swift
//  Ana Gym
//
//  Created by Esslam Emad on 13/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation
import Moya

enum APIRequests {
    
    
    case login(email: String, password: String)
    case editUser(variables: Dictionary<String,Any>)
    case register(user: User)
    case forgotPassword(phone: String)
    case updateToken(id: Int, token: String)
    case getPrograms
    case getProgram(id: Int)
    case subscribeProgram(programID: Int, userID: Int, method: Int, photo: UIImage?)
    case activeProgram(programID: Int, userID: Int)
    case getProgramsForUser(id: Int)
    case getSubscribedProgramForUser(programID: Int, userID: Int)
    case getTrainingDay(programID: Int, userID: Int, dayID: Int)
    case getNutrition(programID: Int, userID: Int, nutritionID: Int)
    case getCategories
    case getProductsInCategory(categoryID: Int)
    case getProducts
    case getProduct(id: Int)
    case getBestSellerProducts
    case getLatestProducts
    case contactUs(name: String, email: String, message: String, phone: String)
    case getPages
    case getPage(id: Int)
    case upload(image: UIImage)
    case getUserCart(id: Int)
    case addToCart(cart: Cart)
    case saveOrder(details: SaveOrder)
    case getFood(programID: Int, userID: Int, foodID: Int)
    case getCalory(programID: Int, userID: Int, caloryID: Int)
    case showPaypalPage(programID: Int, userID: Int)
    case fregister(user: User)
    case fsubscribe(programID: Int, userID: Int)
}


extension APIRequests: TargetType{
    var baseURL: URL{
        switch self{
        default:
            return URL(string: "https://anagym.com/ar/mobile/")!
        /*default:
            return URL(string: "https://sh.alyomhost.net/anafit/ar/mobile/")!*/
        }
        
    }
    var path: String{
        switch self{
        case .register:
            return "register"
        case .login:
            return "login"
        case .editUser:
            return "editUser"
        case .forgotPassword:
            return "forgotPassword"
        case .updateToken:
            return "updateToken"
        case .getPrograms:
            return "getPrograms"
        case .getProgram(id: let id):
            return "getPrograms/\(id)"
        case .subscribeProgram:
            return "subscribeProgram"
        case .activeProgram:
            return "activeProgram"
        case .getProgramsForUser(id: let id):
            return "getUserPrograms/\(id)"
        case .getSubscribedProgramForUser(programID: let programID, userID: let userID):
            return "getProgram/\(programID)/\(userID)"
        case .getTrainingDay(programID: let programID, userID: let userID, dayID: let dayID):
            return "trainingDay/\(dayID)/\(programID)/\(userID)"
        case .getNutrition(programID: let programID, userID: let userID, nutritionID: let nutritionID):
            return "getNutrition/\(nutritionID)/\(programID)/\(userID)"
        case .getCategories:
            return "getCategory"
        case .getProductsInCategory(categoryID: let id):
            return "getProducts/\(id)"
        case .getProducts:
            return "getProducts"
        case .getProduct(id: let id):
            return "getProduct/\(id)"
        case .getBestSellerProducts:
            return "bestSellers"
        case .getLatestProducts:
            return "latestProducts"
        case .contactUs:
            return "contactUs"
        case .getPages:
            return "pages"
        case .getPage(id: let id):
            return "pages/\(id)"
        case .upload:
            return "upload"
        case .getUserCart(id: let id):
            return "getUserCart/\(id)"
        case .addToCart:
            return "addToCart"
        case .saveOrder:
            return "saveOrder"
        case .getFood(programID: let programID, userID: let userID, foodID: let foodID):
            return "getFood/\(foodID)/\(programID)/\(userID)"
        case .getCalory(programID: let programID, userID: let userID, caloryID: let caloryID):
            return "getCalory/\(caloryID)/\(programID)/\(userID)"
        case .showPaypalPage(programID: let pid, userID: let uid):
            return "showPaypalPage/\(uid)/\(pid)"
        case .fregister:
            return "registerFree"
        case .fsubscribe:
            return "subscribeProgramFree"
            
        }
    }
    
    
    var method: Moya.Method{
        switch self{
        case .saveOrder, .addToCart, .upload, .contactUs, .activeProgram, .subscribeProgram, .updateToken, .forgotPassword, .editUser, .login, .register, .showPaypalPage, .fregister, .fsubscribe:
            return .post
            
        default:
            return .get
        }
    }
    
    
    
    var task: Task{
        switch self{
            
        case .register(user: let user1):
            return .requestJSONEncodable(user1)
            
        case .login(email: let email, password: let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case.editUser(variables: let dict):
            return .requestParameters(parameters: dict, encoding: JSONEncoding.default)
        case .forgotPassword(phone: let phone):
            return .requestParameters(parameters: ["phone": phone], encoding: JSONEncoding.default)
        case .updateToken(id: let id , token: let token):
            return .requestParameters(parameters: ["user_id": id, "token": token], encoding: JSONEncoding.default)
            
            
            
            
            
        case .subscribeProgram(programID: let programID, userID: let userID, method: let method, photo: let photo):
            
            
            
            
            if let photo = photo{
                var multipartData = [MultipartFormData]()
                var data: Data?
                data = photo.jpegData(compressionQuality: 0.75)!
                let imageData = MultipartFormData(provider: .data(data!), name: "photo", fileName: "image.jpeg", mimeType: "image/jpeg")
                let pidData = MultipartFormData(provider: .data(String(programID).data(using: .utf8)!), name: "program_id")
                let uidData = MultipartFormData(provider: .data(String(userID).data(using: .utf8)!), name: "user_id")
                let methodData = MultipartFormData(provider: .data(String(method).data(using: .utf8)!), name: "method")
                multipartData = [pidData,uidData,methodData,imageData]
                return .uploadMultipart(multipartData)
                
            }
            
            return .requestParameters(parameters: ["program_id": programID, "user_id": userID, "method": method], encoding: JSONEncoding.default)
            
            
            
            
            
            
        case .activeProgram(programID: let programID, userID: let userID):
            return .requestParameters(parameters: ["program_id": programID, "user_id": userID], encoding: JSONEncoding.default)
        case .contactUs(name: let name, email: let email , message: let message, phone: let phone):
            return .requestParameters(parameters: ["name": name, "email": email, "message": message, "phone": phone], encoding: JSONEncoding.default)
        case .upload(image: let image):
            let data = image.jpegData(compressionQuality: 0.75)!
            let imageData = MultipartFormData(provider: .data(data), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            let multipartData = [imageData]
            return .uploadMultipart(multipartData)
        case .addToCart(cart: let cart):
            return .requestJSONEncodable(cart)
        case .saveOrder(details: let details):
            return .requestJSONEncodable(details)
        //case .showPaypalPage(programID: let pid, userID: let uid):
        //    return .requestParameters(parameters: ["program_id": pid, "user_id": uid], encoding: JSONEncoding.default)
            
        case .fregister(user: let user):
            return .requestJSONEncodable(user)
        case .fsubscribe(programID: let pid, userID: let uid):
            return .requestParameters(parameters: ["program_id": pid, "user_id": uid], encoding: JSONEncoding.default)
        default:
            return .requestPlain
            
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json",
                "client": "a63e6de4fd0ae87da84395d1b0303bc0efeaee9f",
                "secret": "1114f4f8a99108ef7ef709b1e40074e482da230f"]
    }
}
