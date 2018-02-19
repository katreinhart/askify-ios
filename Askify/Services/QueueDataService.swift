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
    var archive: [Question] = []
    
    func fetchQueue(completion: @escaping CompletionHandler) {
        let header = UserDataService.instance.bearerHeader()
        
        Alamofire.request(QUEUE_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error != nil {
                debugPrint(response.result.error)
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
                
                var newQuestion = Question(question: q, answered: answered, answer: nil, user_id: userid, user_name: fname)
                self.queue.append(newQuestion)
            }
            
            debugPrint(self.queue)
            completion(true)
        }
    }
    
    func fetchArchive(completion: @escaping CompletionHandler) {
        
    }
    
    func postQuestion(question: String, completion: @escaping CompletionHandler) {
        
    }
    
    func postAnswer(answer: String, completion: @escaping CompletionHandler) {
        
    }
}
