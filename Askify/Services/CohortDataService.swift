//
//  CohortDataService.swift
//  Askify
//
//  Created by Katherine Reinhart on 2/20/18.
//  Copyright © 2018 reinhart.digital. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CohortDataService {
    static let instance = CohortDataService()
    
    var cohorts : [String] = []
    
    func fetchCohortList(completion: @escaping CompletionHandler) {
        
        Alamofire.request(FETCH_COHORT_LIST, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error != nil {
                debugPrint("error fetching cohort list")
                completion(false)
            } else {
                guard let data = response.data else { return }
                let json = JSON(data: data)
                
                for (_, item) in json {
                    self.cohorts.append(item["cohort"].stringValue)
                }
                debugPrint(self.cohorts)
                completion(true)
            }
        }
    }
}
