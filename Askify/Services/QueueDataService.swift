//
//  QueueDataService.swift
//  Askify
//
//  Created by Katherine Reinhart on 2/16/18.
//  Copyright © 2018 reinhart.digital. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class QueueDataService {
    
    static let instance = QueueDataService()
    
    // Instance variables
    var queue: [Question] = []
    var archive: [AnsweredQuestion] = []
    
    func fetchQueue(completion: @escaping CompletionHandler) {
        let header = UserDataService.instance.bearerHeader()
        // Empty out queue so it does not repeat info
        queue = []
        
        Alamofire.request(QUEUE_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error != nil {
                debugPrint(response.result.error ?? "Error fetching queue")
                completion(false)
                return
            }
            
            guard let data = response.data else {return}
            let json = JSON(data: data)
            
            for (_, value) in json {
                let q = value["question"].stringValue
                let answered = value["answered"].boolValue
                let userid = value["userid"].intValue
                let cohort = value["cohort"].stringValue
                let fname = value["fname"].stringValue
                
                let newQuestion = Question(question: q, answered: answered, answer: nil, user_id: userid, user_name: fname, cohort: cohort)
                self.queue.append(newQuestion)
            }
            
            debugPrint(self.queue)
            completion(true)
        }
    }
    
    func fetchArchive(completion: @escaping CompletionHandler) {
        let header = UserDataService.instance.bearerHeader()
        archive = []
        
        Alamofire.request(ARCHIVE_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error != nil {
                debugPrint(response.result.error ?? "Error fetching archive")
                completion(false)
                return
            }
            
            guard let data = response.data else {return}
            let json = JSON(data: data)
            
            for (_, value) in json {
                let q = value["question"].stringValue
                let userid = value["userid"].intValue
                let cohort = value["cohort"].stringValue
                let fname = value["fname"].stringValue
                let id = value["id"].intValue
//                let answers = value["answers"].arrayValue
                
                let newAnsweredQuestion = AnsweredQuestion(id: id, question: q, answered: true, answers: [], user_id: userid, user_name: fname, cohort: cohort)
                
//                for (_, ans) in answers {
//                    let answer = ans["answer"].stringValue
//                    let uid = ans["userid"].intValue
//                    let name = ans["fname"].stringValue
//                    let newAns = Answer(answer: answer, userid: uid, name: name)
//
//                    newAnsweredQuestion.answers.append(newAns)
//                }
                self.archive.append(newAnsweredQuestion)
            }
            
            debugPrint(self.archive)
            completion(true)
        }
    }
    
    func postQuestion(question: String, completion: @escaping CompletionHandler) {
        let header = UserDataService.instance.bearerHeader()
        let body = [
            "question": question,
            "fname": UserDataService.instance.name,
            "cohort": UserDataService.instance.cohort
        ]
        debugPrint(header, body, POST_QUESTION_URL)
        Alamofire.request(POST_QUESTION_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error != nil {
                debugPrint(response.result.error ?? "")
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
    
    func postAnswer(answer: String, completion: @escaping CompletionHandler) {
        
    }
}
