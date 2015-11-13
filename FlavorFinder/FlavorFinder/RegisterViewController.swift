//
//  RegisterViewController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 10/24/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit
import Parse


class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    //// somewhere we need a privacy policy :)
    
    // validation error messages
    let EMAIL_INVALID = "That doesn't look like an email!"
    let USERNAME_INVALID = "Usernames must be between \(USERNAME_CHAR_MIN) and \(USERNAME_CHAR_MAX) characters."
    let PASSWORD_INVALID = "Passwords must be between \(PASSWORD_CHAR_MIN) and \(PASSWORD_CHAR_MAX) characters."
    let PW_MISMATCH = "Passwords don't match."
    let MULTIPLE_INVALID = "Please fix errors and resubmit."
    //// somewhere other than error messaging we'll want to surface our
    //// pw/username requirements!
    
    // request error messages
    let GENERIC_ERROR = "Oops! An error occurred."
    let USERNAME_IN_USE = "Username already in use."
    let EMAIL_IN_USE = "Email associated with an account."
    
    // MARK: Properties -----------------------------------------------
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var registerMsg: UILabel!
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerUsername: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var registerPasswordRetype: UITextField!
    @IBOutlet weak var registerCOPPA: UILabel!
    @IBOutlet weak var registerSubmitBtn: UIButton!
    
    // MARK: Segue Identifiers ----------------------------------------
    let registerToMatchTable = "segueRegisterToMatchTable"

    // MARK: Actions --------------------------------------------------

    @IBAction func registerSubmitActionBtn(sender: UIButton) {
        if (registerEmail.text != nil && registerUsername.text != nil && registerPassword.text != nil && registerPasswordRetype.text != nil) {
            requestNewUser(registerEmail.text!, username: registerUsername.text!, password: registerPassword.text!, pwRetyped: registerPasswordRetype.text!)
        }
    }
    
    // REGISTER VIEW FUNCTIONS -----------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor_normal = registerEmail.backgroundColor!
        registerEmail.delegate = self
        registerUsername.delegate = self
        registerPassword.delegate = self
        registerPasswordRetype.delegate = self
        registerEmail.setTextLeftPadding(5)
        registerUsername.setTextLeftPadding(5)
        registerPassword.setTextLeftPadding(5)
        registerPasswordRetype.setTextLeftPadding(5)
        
        if let navi = self.navigationController as? MainNavigationController {
            navi.navigationItem.setLeftBarButtonItems([navi.goBackBtn], animated: true)
            navi.navigationItem.setRightBarButtonItems([], animated: true)
            navi.reset_navigationBar()
            navi.goBackBtn.enabled = true
        }
    }
    
    func changeDisabledStatus(submitDisabled: Bool) {
        // anything we want to toggle enabled/disabled based on form submission status
        registerSubmitBtn.enabled = !submitDisabled
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.backgroundColor = backgroundColor_normal
    }
    
    // REGISTER REQUEST FUNCTIONS ---------------------------------------
    func requestNewUser(email: String, username: String, password: String, pwRetyped: String) {
        if fieldsAreValid(email, username: username, password: password, pwRetyped: pwRetyped) {
            changeDisabledStatus(true)
            let newUser = PFUser()
            newUser.username = username
            newUser.email = email
            newUser.password = password
            newUser.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
                if error == nil {
                    if succeeded {
                        self.registerSuccess(newUser)
                    } else {
                        self.handleError(error)
                    }
                } else {
                    self.handleError(error)
                }
            }
        }
    }
    
    func fieldsAreValid(email: String, username: String, password: String, pwRetyped: String) -> Bool {
        var isValid = true
        if isInvalidEmail(email) {
            registerEmail.backgroundColor = backgroundColor_error
            registerMsg.text = EMAIL_INVALID
            isValid = false
        }
        if isInvalidUsername(username) {
            registerUsername.backgroundColor = backgroundColor_error
            if (isValid) {
                registerMsg.text = USERNAME_INVALID
                isValid = false
            } else {
                registerMsg.text = MULTIPLE_INVALID
            }
        }
        if isInvalidPassword(password) {
            registerPassword.backgroundColor = backgroundColor_error
            if (isValid) {
                registerMsg.text = PASSWORD_INVALID
                isValid = false
            } else {
                registerMsg.text = MULTIPLE_INVALID
            }
        }
        if pwRetyped.isEmpty {
            registerPasswordRetype.backgroundColor = backgroundColor_error
            registerMsg.text = MULTIPLE_INVALID
            isValid = false
            
            return isValid
        }
        if password != pwRetyped {
            registerPasswordRetype.backgroundColor = backgroundColor_error
            if (isValid) {
                registerMsg.text = PW_MISMATCH
                isValid = false
            } else {
                registerMsg.text = MULTIPLE_INVALID
            }
        }
        return isValid
    }
    
    func registerSuccess(user: PFUser) {
        registerMsg.text = ""
        let username = user.username
        print("Successfully added new user \(username!)")
        // now log user in to app and go to table
        setUserSession(user)
        self.performSegueWithIdentifier(self.registerToMatchTable,
            sender: self)
    }
    
    func handleError(error: NSError?) {
        self.changeDisabledStatus(false) // allow resubmission
        if let error = error {
            print("\(error)")
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
    
}
