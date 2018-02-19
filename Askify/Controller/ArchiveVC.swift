//
//  ArchiveVC.swift
//  Askify
//
//  Created by Katherine Reinhart on 2/16/18.
//  Copyright © 2018 reinhart.digital. All rights reserved.
//

import UIKit

class ArchiveVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var archiveTV: UITableView!
    
    // Variables
    var archive : [AnsweredQuestion] = []
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        QueueDataService.instance.fetchArchive { (success) in
            if success {
                self.archive = QueueDataService.instance.archive
                self.archiveTV.reloadData()
            } else {
                debugPrint("Somethign went wrong fetching archive")
            }
        }
        archiveTV.dataSource = self
        archiveTV.delegate = self
    }

    // Protocol methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archive.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed(ARCHIVE_CELL, owner: self, options: nil)?.first as! ArchiveTVCell
        let answeredQuestion = QueueDataService.instance.archive[indexPath.row]
        
        cell.archiveQuestionLbl.text = answeredQuestion.question
        cell.archiveNumberLbl.text = String(answeredQuestion.id)
        cell.userNameLbl.text = answeredQuestion.user_name ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
