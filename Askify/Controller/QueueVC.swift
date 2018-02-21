//
//  QueueVC.swift
//  Askify
//
//  Created by Katherine Reinhart on 2/16/18.
//  Copyright © 2018 reinhart.digital. All rights reserved.
//

import UIKit

class QueueVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UpdateAnswerDelegate {
    
    @IBOutlet weak var questionTextField: UITextView!
    @IBOutlet weak var askifyButton: UIButton!
    @IBOutlet weak var queueTV: UITableView!
    @IBOutlet weak var queuePosition: UILabel!
    
    var queue = [Question]()
    
    private let refreshControl = UIRefreshControl()
    private let placeholderQ = Question(id: 0, question: "", answered: false, answer: "", user_id: 0, user_name: nil, cohort: "")
    
    private var isEditingAtIndex: Int = 0
    private var editingQuestion: Question?
    
    // Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        QueueDataService.instance.fetchQueue { (success) in
            if success {
                self.queue = QueueDataService.instance.queue
                self.queuePosition.text = String(QueueDataService.instance.queuePosition())
                self.queueTV.reloadData()
                
                if (self.queuePosition.text == "0") {
                    self.askifyButton.isEnabled = true
                    self.askifyButton.backgroundColor = GALVANIZE_ORANGE
                } else {
                    self.askifyButton.isEnabled = false
                    self.askifyButton.backgroundColor = UIColor.lightGray
                }
            } else {
                debugPrint(ERROR_FETCHING_QUEUE)
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
                self.queuePosition.text = String(QueueDataService.instance.queuePosition())
                if (self.queuePosition.text == "0") {
                    self.askifyButton.isEnabled = true
                    self.askifyButton.backgroundColor = GALVANIZE_ORANGE
                } else {
                    self.askifyButton.isEnabled = false
                    self.askifyButton.backgroundColor = UIColor.lightGray
                }
                        
                self.refreshControl.endRefreshing()
                
            } else {
                debugPrint("error fetching updated queue")
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // mocking placeholder text
        if(textView.text == QUESTION_PLACEHOLDER) {
            textView.text = ""
        }
    }
    
    // Table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.queue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let question = self.queue[indexPath.row]
        
        if question.id == placeholderQ.id {
            let cell = Bundle.main.loadNibNamed(ANSWER_CELL, owner: self, options: nil)?.first as! inputAnswerTVCell
            cell.delegate = self
            return cell
        }
        
        let cell = Bundle.main.loadNibNamed(QUEUE_CELL, owner: self, options: nil)?.first as! QueueTVCell
        
        cell.queuePosition.text = String(indexPath.row + 1)
        cell.questionLabel.text = question.question
        if String(question.user_id) == UserDataService.instance.userID {
            // show answer button if it is user's own question, not otherwise
            cell.answerButton.isHidden = false
            cell.userNameLbl.isHidden = true
        } else {
            cell.answerButton.isHidden = true
            cell.userNameLbl.text = question.user_name ?? ""
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isEditingAtIndex == 0 || (indexPath.row + 1) != isEditingAtIndex {
            // normal cells are 80 height
            return 80
        } else {
            // special input answer cell is 173 height
            return 173
        }
        
    }
    
    // Swipe to edit
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextualMarkAnsweredAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    
    func contextualMarkAnsweredAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let question = self.queue[indexPath.row]
        
        let action = UIContextualAction(style: .normal, title: "Mark Answered") { (contextAction: UIContextualAction, sourceView: UIView, completion: @escaping CompletionHandler) in
            
            if String(question.user_id) == UserDataService.instance.userID {
                self.editingQuestion = self.queue[indexPath.row]
                self.queue.insert(self.placeholderQ, at: indexPath.row)
                self.isEditingAtIndex = indexPath.row + 1
                self.queueTV.reloadData()
                completion(true)
            } else {
                completion(false)
            }
        }
        
        if String(question.user_id) == UserDataService.instance.userID {
            action.backgroundColor = UIColor.orange
        } else {
            action.backgroundColor = UIColor.white
            action.title = ""
        }
        
        return action
    
    }
    
    // UpdateAnswerDelegate methods
    
    func didPressCancelButton(_ sender: inputAnswerTVCell) {
        queue[isEditingAtIndex] = editingQuestion!
        isEditingAtIndex = 0
        editingQuestion = nil
        self.refreshQueueView((Any).self)
    }
    
    func didPressSubmitButton(_ sender: inputAnswerTVCell, answer: String) {
        guard let question = editingQuestion else {return}
        
        QueueDataService.instance.markQuestionAnswered(id: question.id, answer: answer) { (success) in
            if(success) {
                self.queue = self.queue.filter({ (q) -> Bool in
                    return q.id != 0
                })
                self.isEditingAtIndex = 0
                self.refreshQueueView((Any).self)
            } else {
                debugPrint ("Something went wrong marking question as answered.")
            }
        }
    }
 
    // Actions
    @IBAction func askifyButtonPressed(_ sender: Any) {
        if questionTextField.text == "" || questionTextField.text == QUESTION_PLACEHOLDER {
            return
        } else {
            QueueDataService.instance.postQuestion(question: questionTextField.text) {
                (success) in
                if !success {
                    debugPrint("Something went wrong posting question")
                } else {
                    self.questionTextField.text = QUESTION_PLACEHOLDER
                    self.askifyButton.isEnabled = false
                    self.refreshQueueView(self)
                }
            }
        }
    }
}
