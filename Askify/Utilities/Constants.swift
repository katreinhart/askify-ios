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
let API_BASE_URL = "https://askify-api.herokuapp.com"
let LOGIN_URL = "\(API_BASE_URL)/auth/login"
let REGISTER_URL = "\(API_BASE_URL)/auth/register"
let QUEUE_URL = "\(API_BASE_URL)/api/queue"
let ARCHIVE_URL = "\(API_BASE_URL)/api/archive"

// UserDefaults keys
let LOGGED_IN_KEY = "loggedInKey"
let TOKEN_KEY = "tokenKey"
let USER_EMAIL = "userEmail"
let USER_ID = "userID"
let USER_FNAME = "userFName"
let COHORT = "cohort"

// Segues
let TO_LOGIN = "toLogin"
let TO_REGISTER = "toRegister"
let SHOW_LANDING_FROM_SIGNUP = "showLandingFromSignup"
let SHOW_LANDING_FROM_LOGIN = "showLandingFromLogin"

// Storyboard & XIB IDs
let QUEUE_VC = "queueView"
let ARCHIVE_VC = "archiveView"
let QUEUE_CELL = "QueueTVCell"
let ARCHIVE_CELL = "ArchiveTVCell"


// Headers
//let BEARER_HEADER = [
//    "authorization": "Bearer \(TOKEN)",
//    "Content-Type": "application/json; charset=utf-8"
//]

let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]

