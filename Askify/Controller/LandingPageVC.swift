//
//  ViewController.swift
//  Askify
//
//  Created by Katherine Reinhart on 2/16/18.
//  Copyright © 2018 reinhart.digital. All rights reserved.
//

import UIKit

class LandingPageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: TO_LOGIN, sender: self)
    }

    @IBAction func registerBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: TO_REGISTER, sender: self)
    }
}

