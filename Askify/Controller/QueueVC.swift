//
//  QueueVC.swift
//  Askify
//
//  Created by Katherine Reinhart on 2/16/18.
//  Copyright © 2018 reinhart.digital. All rights reserved.
//

import UIKit

class QueueVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionTextField: UITextView!
    @IBOutlet weak var askifyButton: UIButton!
    @IBOutlet weak var queueTV: UITableView!
    
    // Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        QueueDataService.instance.fetchQueue { (success) in
            if success {
                debugPrint("Successfully fetched queue")
                
            } else {
                debugPrint("Something went wrong")
            }
        }
        
        queueTV.dataSource = self
        queueTV.delegate = self
    }
    
    // Protocol methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    // Actions
    @IBAction func askifyButtonPressed(_ sender: Any) {
        debugPrint("Askify button pressed!")
    }
}
