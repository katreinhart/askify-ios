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
    var profileVC: UIViewController!
    
    var viewControllers: [UIViewController]!
    
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        queueVC = storyboard.instantiateViewController(withIdentifier: QUEUE_VC)
        archiveVC = storyboard.instantiateViewController(withIdentifier: ARCHIVE_VC)
        profileVC = storyboard.instantiateViewController(withIdentifier: PROFILE_VC)
        
        viewControllers = [queueVC, archiveVC, profileVC]
        
        Buttons[selectedIndex].isSelected = true
        
        tabPressed(Buttons[selectedIndex])
    }
    
    @IBAction func tabPressed(_ sender: UIButton) {
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        
        Buttons[previousIndex].isSelected = false
        
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        
        sender.isSelected = true
        
        let vc = viewControllers[selectedIndex]
        addChildViewController(vc)
        vc.view.frame = ContentView.bounds
        ContentView.addSubview(vc.view)
        
        vc.didMove(toParentViewController: self)
    }
}
