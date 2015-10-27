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


class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    //// somewhere we need a privacy policy :)
    
    /// arbitrarily chosen atm but we can set these...
    /// CHECK PARSE!
    var USERNAME_CHAR_MAX = 50;
    var USERNAME_CHAR_MIN = 1;
    var PASSWORD_CHAR_MIN = 6;
    var PASSWORD_CHAR_MAX = 50;
    
    // error messages
    var GENERIC_ERROR = "Oops! An error occurred.";
    var USERNAME_IN_USE = "Username already in use.";
    var EMAIL_IN_USE = "Email associated with an account.";
    
    var isValid: Bool = true
    var backgroundColor_normal: UIColor!
    var backgroundColor_error: UIColor = UIColor(red: 250/255.0, green: 126/255.0, blue: 107/255.0, alpha: 0.5)
    // MARK: Properties -----------------------------------------------
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var registerMsg: UILabel!
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerUsername: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var registerCOPPA: UILabel!
    
    // MARK: Segue Identifiers ----------------------------------------
    /// eventually segue to logged in!

    // MARK: Actions --------------------------------------------------

    @IBAction func registerSubmitActionBtn(sender: UIButton) {
        if (registerEmail.text != nil && registerUsername.text != nil && registerPassword.text != nil) {
            requestNewUser(registerEmail.text!, username: registerUsername.text!, password: registerPassword.text!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor_normal = registerEmail.backgroundColor!
        registerEmail.delegate = self
        registerUsername.delegate = self
        registerPassword.delegate = self
        
        registerEmail.setTextLeftPadding(5)
        registerUsername.setTextLeftPadding(5)
        registerPassword.setTextLeftPadding(5)
    }
    
    // REGISTER FUNCTIONS ---------------------------------------------
    func requestNewUser(email: String, username: String, password: String) {
        if isInvalidEmail(email) {
            registerEmail.backgroundColor = backgroundColor_error
            isValid = false
        }
        if isInvalidUsername(username) {
            registerUsername.backgroundColor = backgroundColor_error
            isValid = false
        }
        if isInvalidPassword(password) {
            registerPassword.backgroundColor = backgroundColor_error
            isValid = false
        }
        if isValid {
            isValid = true
            changeStatus(false)
            let newUser = PFUser()
            newUser.username = username
            newUser.email = email
            newUser.password = password
            newUser.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
                if error == nil {
                    if succeeded {
                        self.registerSuccess()
                    } else {
                        self.handleError(error)
                    }
                } else {
                    self.handleError(error)
                }
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
                registerMsg.text = USERNAME_IN_USE
            } else if error.code == 203 {
                registerMsg.text = EMAIL_IN_USE
            } else {
                registerMsg.text = GENERIC_ERROR
            }
        } else {
            print("nil error")
            registerMsg.text = GENERIC_ERROR
        }
    }
    
    
    
    // VALIDATION FUNCTIONS ------------------------------------------
    func isInvalidEmail(email:String) -> Bool {
        let emailRegex = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return !emailTest.evaluateWithObject(email)
    }
    
    func isInvalidUsername(username: String) -> Bool {
        return username.isEmpty
    }
    
    func isInvalidPassword(password: String) -> Bool {
        return password.isEmpty
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.backgroundColor = backgroundColor_normal
    }
}
