//
//  Auth.swift
//  Ana Gym
//
//  Created by Esslam Emad on 15/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import Foundation
import DefaultsKit
import PromiseKit


class Auth {
    
    static let auth = Auth()
    
   /* var isLanguageSet: Bool{
        return language != nil
    }
    
    var language: String?{
        get {
            return Defaults().get(for: Key<String>("Language"))
        }
        set {
            if let value = newValue {
                Defaults().set(value, for: Key<String>("Language"))
            }
        }
    }*/
    
    
    
    var isSignedIn: Bool? {
        get {
            return Defaults().get(for: Key<Bool>("Signed In"))
        }
        set {
            if let value = newValue{
                Defaults().set(value, for: Key<Bool>("Signed In"))
            }
        }
    }
    
    var user: User? {
        get {
            return Defaults().get(for: Key<User>("user"))
        }
        set {
            if let value = newValue {
                Defaults().set(value, for: Key<User>("user"))
            } else {
                UserDefaults.standard.set(nil, forKey: "user")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    var products: [Product]! {
        get {
            guard let p = Defaults().get(for: Key<[Product]>("products")) else {
                return [Product]()
            }
            return p
        } set {
            if let value = newValue {
                Defaults().set(value, for: Key<[Product]>("products"))
            }
        }
    }
    
    var programs: [Program]! {
        get {
            guard let p = Defaults().get(for: Key<[Program]>("programs")) else {
                return [Program]()
            }
            return p
        } set {
            if let value = newValue {
                Defaults().set(value, for: Key<[Program]>("programs"))
            }
        }
    }
    
    var subscribedPrograms: [Program]! {
        get {
            guard let p = Defaults().get(for: Key<[Program]>("subscribed programs")) else {
                return [Program]()
            }
            return p
        } set {
            if let value = newValue {
                Defaults().set(value, for: Key<[Program]>("subscribed programs"))
            }
        }
    }
    
    var production: Bool! {
        get {
            return Defaults().get(for: Key<Bool>("C"))
        } set {
            if let value = newValue {
                Defaults().set(value, for: Key<Bool>("C"))
            }
        }
    }
    
    var pages: [Page]! {
        get {
            guard let p = Defaults().get(for: Key<[Page]>("pages")) else {
                return [Page]()
            }
            return p
        } set {
            if let value = newValue {
                Defaults().set(value, for: Key<[Page]>("pages"))
            }
        }
    }
    
    var fcmToken: String! {
        get{
            return Defaults().get(for: Key<String>("Token"))
        }
        set {
            if let value = newValue {
                Defaults().set(value, for: Key<String>("Token"))
            }
        }
    }
    
    private init() {
    }
    
    
    func updateToken(){
        if user != nil {
            if user!.token != fcmToken{
                user!.token = fcmToken
                firstly{
                    return API.CallApi(APIRequests.updateToken(id: self.user!.id, token: fcmToken))
                    } .done {
                        self.user = try! JSONDecoder().decode(User.self, from: $0)
                        print("Token updated")
                    }.catch { error in
                        print("Unable to update token")
                }
            }
        }
    }
 
    
    func getPrograms(){
        firstly{
            return API.CallApi(APIRequests.getPrograms)
            }.done {
                self.programs = try! JSONDecoder().decode([Program].self, from: $0)
                self.production = self.programs[0].production ?? true
            }.catch { error in
                self.getPrograms()
        }
    }
    
    func getProducts(){
        firstly{
            return API.CallApi(APIRequests.getProducts)
            }.done {
                self.products = try! JSONDecoder().decode([Product].self, from: $0)
            }.catch { error in
                self.getProducts()
        }
    }
    
    func getSubscribedPrograms(){
        firstly{
            return API.CallApi(APIRequests.getProgramsForUser(id: (self.user?.id)!))
            }.done{
                self.subscribedPrograms = try! JSONDecoder().decode([Program].self, from: $0)
            }.catch { error in
               // self.getSubscribedPrograms()
        }
    }
    
    func getPages(){
        firstly{
            return API.CallApi(APIRequests.getPages)
            }.done{
                self.pages = try! JSONDecoder().decode([Page].self, from: $0)
            }.catch { error in
                self.getPages()
        }
    }
    
    func logout() {
        user = nil
        isSignedIn = false
        subscribedPrograms = [Program]()
    }
    
}
