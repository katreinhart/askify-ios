//
//  QueueVC.swift
//  Askify
//
//  Created by Katherine Reinhart on 2/16/18.
//  Copyright © 2018 reinhart.digital. All rights reserved.
//

import UIKit

class QueueVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var questionTextField: UITextView!
    @IBOutlet weak var askifyButton: UIButton!
    @IBOutlet weak var queueTV: UITableView!
    @IBOutlet weak var queuePosition: UILabel!
    
    var queue = [Question]()
    
    private let refreshControl = UIRefreshControl()
    
    // Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        QueueDataService.instance.fetchQueue { (success) in
            if success {
                debugPrint("Successfully fetched queue")
                self.queue = QueueDataService.instance.queue
                self.queueTV.reloadData()
            } else {
                debugPrint("Something went wrong")
            }
        }
        
        queueTV.dataSource = self
        queueTV.delegate = self
        questionTextField.delegate = self
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            queueTV.refreshControl = refreshControl
        } else {
            queueTV.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshQueueView(_:)), for: .valueChanged)
    }
    
    @objc private func refreshQueueView(_ sender: Any) {
        QueueDataService.instance.fetchQueue { (success) in
            if success {
                self.queue = QueueDataService.instance.queue
                self.queueTV.reloadData()
                self.refreshControl.endRefreshing()
                
            } else {
                debugPrint("error fetching updated queue")
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        
    }
    
    // Protocol methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QueueDataService.instance.queue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed(QUEUE_CELL, owner: self, options: nil)?.first as! QueueTVCell
        let question = QueueDataService.instance.queue[indexPath.row]
        cell.queuePosition.text = String(indexPath.row + 1)
        cell.questionLabel.text = question.question
        if String(question.user_id) == UserDataService.instance.userID {
            // show answer button if it is user's own question, not otherwise
            cell.answerButton.isHidden = false
            cell.userNameLbl.isHidden = true
            self.queuePosition.text = String(indexPath.row + 1)
        } else {
            cell.answerButton.isHidden = true
            cell.userNameLbl.text = question.user_name ?? ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // Actions
    @IBAction func askifyButtonPressed(_ sender: Any) {
        debugPrint("Askify button pressed!")
        if questionTextField.text == "" || questionTextField.text == "What's got you blocked?" {
            return
        } else {
            QueueDataService.instance.postQuestion(question: questionTextField.text) {
                (success) in
                if !success {
                    debugPrint("Something went wrong")
                } else {
                    self.refreshQueueView(self)
                }
            }
        }
    }
}
