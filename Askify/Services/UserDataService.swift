//
//  UserDataService.swift
//  Askify
//
//  Created by Katherine Reinhart on 2/16/18.
//  Copyright © 2018 reinhart.digital. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserDataService {
    
    static let instance = UserDataService()
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var userID: String {
        get {
            return defaults.string(forKey: USER_ID) ?? ""
        }
        set {
            defaults.set(newValue, forKey: USER_ID)
        }
    }
    
    var authToken : String {
        get {
            return defaults.string(forKey: TOKEN_KEY) ?? ""
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail : String {
        get {
            return defaults.string(forKey: USER_EMAIL) ?? ""
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    var name : String {
        get {
            return defaults.string(forKey: USER_FNAME) ?? ""
        }
        set {
            defaults.set(newValue, forKey: USER_FNAME)
        }
    }
    
    var cohort : String {
        get {
            return defaults.string(forKey: COHORT) ?? ""
        }
        set {
            defaults.set(newValue, forKey: COHORT)
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowercaseEmail = email.lowercased()
        
        let body = [
            "email": lowercaseEmail,
            "password": password
        ]
        
        Alamofire.request(LOGIN_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error != nil {
                debugPrint(response.result.error ?? "Error logging in")
                completion(false)
                return
            }
            
            guard let data = response.data else {return}
            debugPrint(data)
            self.setUserInfo(data: data)
            completion(true)
        }
    }
    
    func registerUser(email: String, password: String, firstname: String, cohort: String, completion: @escaping CompletionHandler) {
        let lowercaseEmail = email.lowercased()
        
        let body = [
            "email": lowercaseEmail,
            "password": password,
            "fname": firstname,
            "cohort": cohort
        ]
        
        Alamofire.request(REGISTER_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error != nil {
                debugPrint(response.result.error ?? "Error registering user")
                completion(false)
                return
            }
            
            guard let data = response.data else { return }
            self.setUserInfo(data: data)
            completion(true)
        }
        
    }
    
    func logoutUser() {
        self.userID = "0"
        self.name = ""
        self.authToken = ""
        self.userEmail = ""
        self.cohort = ""
    }
    
    func setUserInfo(data: Data) {
        let json = JSON(data: data)
        let id = json["id"].stringValue
        let fname = json["fname"].stringValue
        let cohort = json["cohort"].stringValue
        let token = json["token"].stringValue
        let email = json["email"].stringValue
        
        self.userID = id
        self.name = fname
        self.cohort = cohort
        self.userEmail = email
        self.authToken = token
    }
    
    func bearerHeader() -> Dictionary<String, String> {
        return [
            "Authorization": "Bearer \(authToken)",
            "Content-Type": "application/json; charset=utf-8"
        ]
    }
}
