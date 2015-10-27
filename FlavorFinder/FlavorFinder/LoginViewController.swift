//
//  LoginViewController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 10/22/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import Foundation
import UIKit
import Parse
import TextFieldEffects

class LoginViewController: UIViewController {
    
    // MARK: Properties -----------------------------------------------
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginUserTextField: TextFieldEffects!
    @IBOutlet weak var loginPassTextField: UITextField!
    
    
    // MARK: Segue Identifiers ----------------------------------------
    let loginToRegister = "segueLoginToRegister"
    let loginToMatchTable = "segueLoginToMatchTable"


    // MARK: Actions --------------------------------------------------
    @IBAction func loginActionBtn(sender: UIButton) {
        loginUser(loginUserTextField.text, pwField: loginPassTextField.text, msg: loginLabel)
    }
    
    // Send user to RegisterViewController page.
    @IBAction func goRegisterActionBtn(sender: UIButton) {
        self.performSegueWithIdentifier(loginToRegister, sender: self)
    }
    
    // Temporary button to go to main page without logging in
    @IBAction func goTableViewTEMP(sender: UIButton) {
        self.performSegueWithIdentifier(loginToMatchTable, sender: self)
    }
    
    
    // FUNCTIONS -------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
    }
    
    func loginUser(userField: String!, pwField: String!, msg: UILabel!) {
        // Check if empty fields:
        if userField != "" && pwField != "" {
 
            // Authenticate user with Parse
            PFUser.logInWithUsernameInBackground(
                    userField!, password: pwField!) {
                (user: PFUser?, error: NSError?) -> Void in

                if user != nil {
                    // User exists - login and go to matches
                    msg.text = "User exists!"

                } else {
                    // User does not exist.
                    msg.text = "Username and Password not found."
                }
            }
        // Empty Fields:
        } else {
            msg.text = "Must enter both fields to Login"
        }
    }
}
