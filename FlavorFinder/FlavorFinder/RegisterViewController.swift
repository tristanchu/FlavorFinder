//
//  RegisterViewController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 10/24/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import Foundation
import UIKit
import Parse
import TextFieldEffects


class RegisterViewController: UIViewController {
    
    //// somewhere we need a privacy policy :)
    
    /// arbitrarily chosen atm but we can set these...
    var USRNAME_CHAR_MAX = 15;
    var USRNAME_CHAR_MIN = 4;
    var PW_CHAR_MIN = 6;
    var PW_CHAR_MAX = 20;
    
    // error messages
    var GENERIC_ERROR = "Oops! An error occurred.";
    var USERNAME_IN_USE = "Username already in use.";
    var EMAIL_IN_USE = "Email associated with an account.";
    
    // MARK: Properties -----------------------------------------------
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var registerMsg: UILabel!
    @IBOutlet weak var registerEmail: TextFieldEffects!
    @IBOutlet weak var registerUsername: TextFieldEffects!
    @IBOutlet weak var registerPassword: TextFieldEffects!
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
        //// trim excess spaces?
        changeStatus(false);
        var newUser = PFUser();
        newUser.username = username;
        newUser.email = email;
        newUser.password = pw;
        newUser.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
            if error == nil {
                if succeeded {
                    self.registerSuccess()
                } else {
                    self.handleError(error);
                }
            } else {
                self.handleError(error);
            }
        }
    }
    
    func registerSuccess() {
        //// success!
    }
    
    func changeStatus(submitDisabled: Bool) {
        if submitDisabled {
            
        } else {
            
        }
    }
    
    func handleError(error: NSError?) {
        self.changeStatus(false); // allow resubmission
        if let error = error {
            print("\(error)");
            if error.code == 202 {
                registerMsg.text = USERNAME_IN_USE;
            } else if error.code == 203 {
                registerMsg.text = EMAIL_IN_USE;
            } else {
                registerMsg.text = GENERIC_ERROR;
            }
        } else {
            print("nil error");
            registerMsg.text = GENERIC_ERROR;
        }
    }
    
    
    
    // VALIDATION FUNCTIONS ------------------------------------------
    func hasInvalidEmail(email: String) -> Bool {
        if (email.isEmpty || !email.containsString("@") || !email.containsString(".")) {
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
