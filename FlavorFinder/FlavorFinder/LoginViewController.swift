//
//  LoginViewController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 10/22/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties -----------------------------------------------
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginUserTextField: UITextField!
    @IBOutlet weak var loginPassTextField: UITextField!
    
    
    // MARK: Segue Identifiers ----------------------------------------
    let loginToRegister = "segueLoginToRegister"
    let loginToMatchTable = "segueLoginToMatchTable"


    // MARK: Actions --------------------------------------------------
    @IBAction func loginActionBtn(sender: UIButton) {
        loginUser(loginUserTextField, pwField: loginPassTextField)
    }
    
    // Send user to RegisterViewController page.
    @IBAction func goRegisterActionBtn(sender: UIButton) {
        self.performSegueWithIdentifier(loginToRegister, sender: self)
    }
    
    // Temporary button to go to main page without logging in
    @IBAction func goTableViewTEMP(sender: UIButton) {
        self.performSegueWithIdentifier(loginToMatchTable, sender: self)
    }
    
    
    // LOGIN FUNCTIONS -------------------------------------------------
    
    func loginUser(usernameField: UITextField!, pwField: UITextField!) {
        if usernameField.text != "" && pwField.text != "" {
            // Fields not empty; check if valid user
            self.loginLabel.text = "Tried to login"
            // Change to PFUser.logInWithUsernameInBackground
        } else {
            // Empty Fields:
            self.loginLabel.text = "Must enter both fields to Login"
        }
    }
}
