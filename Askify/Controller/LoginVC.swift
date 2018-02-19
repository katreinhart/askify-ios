//
//  LoginVC.swift
//  Askify
//
//  Created by Katherine Reinhart on 2/16/18.
//  Copyright © 2018 reinhart.digital. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    
    // Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // Actions
    @IBAction func loginBtnPressed(_ sender: Any) {
        guard let email = emailTxt.text else {return}
        guard let password = passTxt.text else {return}
        
        UserDataService.instance.loginUser(email: email, password: password) { (success) in
            
            if(success) {
                self.performSegue(withIdentifier: SHOW_LANDING_FROM_LOGIN, sender: nil)
            } else {
                debugPrint("There was an error with login")
            }
        }
    }
    
}
