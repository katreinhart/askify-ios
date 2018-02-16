//
//  Constants.swift
//  Askify
//
//  Created by Katherine Reinhart on 2/16/18.
//  Copyright © 2018 reinhart.digital. All rights reserved.
//

import Foundation

// typealias for our completion handler
typealias CompletionHandler = (_ Success: Bool) -> ()

// URL Constants
let API_BASE_URL = "https://askify-api.heroku.com"
let LOGIN_URL = "\(API_BASE_URL)/auth/login"
let REGISTER_URL = "\(API_BASE_URL)/auth/register"
let QUEUE_URL = "\(API_BASE_URL)/api/queue"
let ARCHIVE_URL = "\(API_BASE_URL)/api/archive"

// Segues

let TO_LOGIN = "toLogin"
let TO_REGISTER = "toRegister"
let SHOW_LANDING_FROM_SIGNUP = "showLandingFromSignup"
let SHOW_LANDING_FROM_LOGIN = "showLandingFromLogin"


// Headers
let BEARER_HEADER = [
    "authorization": "Bearer \(TOKEN)",
    "Content-Type": "application/json; charset=utf-8"
]

// HARD CODING FOR NOW THIS WILL CHANGE WHEN AUTH IMPLEMENTED
let TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjEsInJvbCI6ZmFsc2UsImV4cCI6MTUxODg5NjEzOX0.szHdzbANn61yBmmurPIKF2zZ8WHJiTRVF9Igx5N0CuQ"
