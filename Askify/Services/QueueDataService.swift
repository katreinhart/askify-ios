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
    
    // Helper function to populate uppper corner indicator as well as determine when to disable
    func queuePosition() -> Int {
        if queue.count == 0 {
            return 0
        }
        let idx = queue.index { (q) -> Bool in
            return String(q.user_id) == UserDataService.instance.userID
        }
        
        return (idx == nil) ? 0 : idx! + 1
    }
    
    func fetchQueue(completion: @escaping CompletionHandler) {
        let header = UserDataService.instance.bearerHeader()
        // Empty out queue so it does not repeat info
        queue = []
        
        Alamofire.request(QUEUE_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error != nil {
                debugPrint(response.result.error ?? ERROR_FETCHING_QUEUE)
                if(response.data?.count == 0) {
                    debugPrint("Zero entries found")
                    completion(true)
                    return
                }
                completion(false)
                return
            }
            
            guard let data = response.data else {return}
            let json = JSON(data: data)
            
            for (_, value) in json {
                let id = value["id"].intValue
                let q = value["question"].stringValue
                let answered = value["answered"].boolValue
                let userid = value["userid"].intValue
                let cohort = value["cohort"].stringValue
                let fname = value["fname"].stringValue
                
                let newQuestion = Question(id: id, question: q, answered: answered, answer: nil, user_id: userid, user_name: fname, cohort: cohort)
                self.queue.append(newQuestion)
            }
            
            completion(true)
        }
    }
    
    func fetchArchive(completion: @escaping CompletionHandler) {
        let header = UserDataService.instance.bearerHeader()
        archive = []
        
        Alamofire.request(ARCHIVE_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error != nil {
                debugPrint(response.result.error ?? ERROR_FETCHING_ARCHIVE)
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
    
    func markQuestionAnswered(id: Int, answer: String, completion: @escaping CompletionHandler) {
        let header = UserDataService.instance.bearerHeader()
        let url = "\(API_BASE_URL)/api/questions/\(id)/answers"
        let body = [
            "answer": answer,
            "fname": UserDataService.instance.name,
            "cohort": UserDataService.instance.cohort
        ]
        
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error != nil {
                debugPrint(ERROR_POSTING_RESPONSE)
                debugPrint(response.result.error as Any)
                completion(false)
            }
            else {
                debugPrint("success")
                completion(true)
            }
        }
    }
    
    func postAnswer(answer: String, completion: @escaping CompletionHandler) {
        
    }
}
