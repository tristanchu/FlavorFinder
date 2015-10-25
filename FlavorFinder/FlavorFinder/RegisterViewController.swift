//
//  RegisterViewController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 10/24/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import Foundation
import UIKit


class RegisterViewController: UIViewController {
    
    //// somewhere we need a privacy policy :)
    
    // MARK: Properties -----------------------------------------------
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerUsername: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var registerCOPPA: UILabel!
    
    // MARK: Segue Identifiers ----------------------------------------
    /// eventually segue to logged in!

    // MARK: Actions --------------------------------------------------

    @IBAction func registerSubmitActionBtn(sender: UIButton) {
        if (registerEmail.text != nil && registerUsername.text != nil && registerPassword.text != nil) {
            requestNewUser(registerEmail.text!, username: registerUsername.text!, pw: registerPassword.text!);
        }
    }
    
    // REGISTER FUNCTIONS ---------------------------------------------
    func requestNewUser(email: String, username: String, pw: String) {
        if (hasInvalidEmail(email)) {
            return;
        }
        if (hasInvalidUsername(username)) {
            return;
        }
        if (hasInvalidPassword(pw)) {
            return;
        }
        
     /// here, send new parse request for new user credentials
    }
    
    func registerSuccess() {
        //// success!
    }
    
    // VALIDATION FUNCTIONS ------------------------------------------
    func hasInvalidEmail(email: String) -> Bool {
        if (email.isEmpty) {
            return true;
        }
        return false;
    }
    
    func hasInvalidUsername(username: String) -> Bool {
        if (username.isEmpty) {
            return true;
        }
        return false;
    }
    
    func hasInvalidPassword(pw: String) -> Bool {
        if (pw.isEmpty) {
            return true;
        }
        return false;
    }
    
}
