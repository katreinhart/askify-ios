//
//  ProfileVC.swift
//  Askify
//
//  Created by Katherine Reinhart on 2/21/18.
//  Copyright © 2018 reinhart.digital. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var cohortLbl: UILabel!
    @IBOutlet weak var queuePositionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = "Name: \(UserDataService.instance.name)"
        emailLbl.text = "Email: \(UserDataService.instance.userEmail)"
        cohortLbl.text = "Cohort: \(UserDataService.instance.cohort)"
        
        queuePositionLbl.text = String(QueueDataService.instance.queuePosition())
    }

    @IBAction func logoutButtonPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        self.performSegue(withIdentifier: SHOW_SPLASH, sender: nil)
    }
    
}
