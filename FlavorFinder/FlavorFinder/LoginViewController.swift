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
        loginUser(loginUserTextField.text, password: loginPassTextField.text, msg: loginLabel)
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
        
        loginUserTextField.setTextLeftPadding(5)
        loginPassTextField.setTextLeftPadding(5)
    }
    
    func loginUser(username: String!, password: String!, msg: UILabel!) {
        // Check if empty fields:
        if isInvalidUsername(username) {
            
        }
        if isInvalidPassword(password) {
            
        }
        
        if username != "" && password != "" {
 
            // Authenticate user with Parse
            PFUser.logInWithUsernameInBackground(
                    username!, password: password!) {
                (user: PFUser?, error: NSError?) -> Void in

                if user != nil {
                    // User exists - login and go to matches
                    msg.text = "User exists!"

                } else {
                    // User does not exist.
                    msg.text = "Incorrect username or password."
                }
            }
        // Empty Fields:
        } else {
            msg.text = "Must enter both fields to login"
        }
    }
}
