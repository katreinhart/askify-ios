//
//  RegisterVC.swift
//  Askify
//
//  Created by Katherine Reinhart on 2/16/18.
//  Copyright © 2018 reinhart.digital. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {


    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var cohortLbl: UILabel!
    @IBOutlet weak var cohortPicker: UIPickerView!
    @IBOutlet weak var signUpBtn: RoundedButton!
    
    var cohorts : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        cohortPicker.dataSource = self
        cohortPicker.delegate = self
        
        cohortPicker.isHidden = true
        
        CohortDataService.instance.fetchCohortList {
            (success) in
            if success {
                self.cohorts = CohortDataService.instance.cohorts
                self.cohortPicker.reloadAllComponents()
            } else {
                debugPrint("something went wrong fetching cohort list")
            }
        }
    }
    
    // Picker View Delegate Protocol Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cohorts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cohortLbl.text = cohorts[row]
        cohortLbl.textColor = UIColor.white
        cohortPicker.isHidden = true
        signUpBtn.isHidden = false
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cohorts[row]
    }
    
    // IB Actions
    @IBAction func selectCohortBtnPressed(_ sender: Any) {
        cohortPicker.isHidden = false
        signUpBtn.isHidden = true
    }
    
    @IBAction func signupBtnPressed(_ sender: Any) {
        guard let email = emailTxtField.text else {return}
        guard let password = passwordTxtField.text else {return}
        guard let name = firstNameTxtField.text else {return}
        guard let cohort = cohortLbl.text else {return}
        
        UserDataService.instance.registerUser(email: email, password: password, firstname: name, cohort: cohort) { (success) in
            if success {
                self.performSegue(withIdentifier: SHOW_LANDING_FROM_SIGNUP, sender: nil)
            } else {
                debugPrint("Something went wrong with registration")
            }
        }
    }
    

    
}
