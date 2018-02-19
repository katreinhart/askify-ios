//
//  Queue.swift
//  Askify
//
//  Created by Katherine Reinhart on 2/16/18.
//  Copyright © 2018 reinhart.digital. All rights reserved.
//

import Foundation

struct Question {
    var question: String
    var answered: Bool
    var answer: String?
    var user_id: Int
    var user_name: String?
    var cohort: String
}

struct AnsweredQuestion {
    var id: Int
    var question: String
    var answered: Bool
    var answers: [Answer]
    var user_id: Int
    var user_name: String?
    var cohort: String
}

struct Answer {
    var answer: String
    var user_id: Int
    var name: String
}
