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
    
    // validation error messages
    var EMAIL_INVALID = "That doesn't look like an email!"
    var USERNAME_INVALID = "Usernames must be between \(USERNAME_CHAR_MIN) and \(USERNAME_CHAR_MAX) characters."
    var PASSWORD_INVALID = "Passwords must be between \(PASSWORD_CHAR_MIN) and \(PASSWORD_CHAR_MAX) characters."
    var MULTIPLE_INVALID = "Please fix errors and resubmit."
    //// somewhere other than error messaging we'll want to surface our
    //// pw/username requirements!
    
    // request error messages
    var GENERIC_ERROR = "Oops! An error occurred."
    var USERNAME_IN_USE = "Username already in use."
    var EMAIL_IN_USE = "Email associated with an account."
    
    // MARK: Properties -----------------------------------------------
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var registerMsg: UILabel!
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerUsername: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var registerCOPPA: UILabel!
    @IBOutlet weak var registerSubmitBtn: UIButton!
    
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
        
        if let navi = self.navigationController as? MainNavigationController {
            navi.navigationItem.setLeftBarButtonItems([navi.goBackBtn], animated: true)
            navi.navigationItem.setRightBarButtonItems([], animated: true)
            navi.reset_navigationBar()
        }
    }
    
    // REGISTER FUNCTIONS ---------------------------------------------
    func requestNewUser(email: String, username: String, password: String) {
        var isValid = true;
        if isInvalidEmail(email) {
            registerEmail.backgroundColor = backgroundColor_error
            registerMsg.text = EMAIL_INVALID;
            isValid = false
        }
        if isInvalidUsername(username) {
            registerUsername.backgroundColor = backgroundColor_error
            if (isValid) {
                registerMsg.text = USERNAME_INVALID;
            } else {
                registerMsg.text = MULTIPLE_INVALID;
            }
            isValid = false
        }
        if isInvalidPassword(password) {
            registerPassword.backgroundColor = backgroundColor_error
            if (isValid) {
                registerMsg.text = PASSWORD_INVALID;
            } else {
                registerMsg.text = MULTIPLE_INVALID;
            }
            isValid = false
        }
        if isValid {
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
            registerSubmitBtn.enabled = false;
        } else {
            registerSubmitBtn.enabled = true;
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.backgroundColor = backgroundColor_normal
    }
}
