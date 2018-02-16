//
//  TabNavigationVC.swift
//  Askify
//
//  Created by Katherine Reinhart on 2/16/18.
//  Copyright © 2018 reinhart.digital. All rights reserved.
//

import UIKit

class TabNavigationVC: UIViewController {

    // Outlets
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet var Buttons: [UIButton]!
    
    // Variables
    var queueVC: UIViewController!
    var archiveVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
