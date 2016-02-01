//
//  RegisterView.swift
//  FlavorFinder
//
//  Handles the register view for within the container
//
//  Created by Courtney Ligh on 2/1/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit
import Parse

class RegisterView : UIViewController, UITextFieldDelegate {
    
    // MARK: messages ------------------------------------
    // validation error messages
    let EMAIL_INVALID = "That doesn't look like an email!"
    let USERNAME_INVALID = "Usernames must be between \(USERNAME_CHAR_MIN) and \(USERNAME_CHAR_MAX) characters."
    let PASSWORD_INVALID = "Passwords must be between \(PASSWORD_CHAR_MIN) and \(PASSWORD_CHAR_MAX) characters."
    let PW_MISMATCH = "Passwords don't match."
    let MULTIPLE_INVALID = "Please fix errors and resubmit."

    // request error messages
    let GENERIC_ERROR = "Oops! An error occurred."
    let USERNAME_IN_USE = "Username already in use."
    let EMAIL_IN_USE = "Email associated with an account."

    // MARK: Properties -----------------------------------

    // Text Labels:
    @IBOutlet weak var signUpPromptLabel: UILabel!
    @IBOutlet weak var warningTextLabel: UILabel!

    // Text Fields:
    @IBOutlet weak var usernameSignUpField: UITextField!
    @IBOutlet weak var pwSignUpField: UITextField!
    @IBOutlet weak var retypePwSignUpField: UITextField!
    @IBOutlet weak var emailSignUpField: UITextField!

    // Buttons (for UI)
    @IBOutlet weak var backToLoginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    let backBtnString =
        String.fontAwesomeIconWithName(.ChevronLeft) + " Back to login"

    // MARK: Actions -----------------------------------
    @IBAction func createAccountAction(sender: AnyObject) {
        if (emailSignUpField.text != nil && usernameSignUpField.text != nil &&
            pwSignUpField.text != nil && retypePwSignUpField.text != nil) {
            // Make request:
            requestNewUser(emailSignUpField.text!,
                username: usernameSignUpField.text!,
                password: pwSignUpField.text!,
                pwRetyped: retypePwSignUpField.text!)
        }
    }

    @IBAction func backToLoginAction(sender: AnyObject) {
        print("clicked back to login")
    }

    // MARK: Override Functions --------------------------

    /* viewDidLoad
            called when app first loads view
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set font awesome chevron:
        backToLoginButton.setTitle(backBtnString, forState: .Normal)

        // set up text fields:
        setUpTextField(usernameSignUpField)
        setUpTextField(pwSignUpField)
        setUpTextField(retypePwSignUpField)
        setUpTextField(emailSignUpField)
    }

    // MARK: Functions ------------------------------------

    /* setUpTextField
        assigns delegate, sets left padding to 5
    */
    func setUpTextField(field: UITextField) {
        field.delegate = self
        field.setTextLeftPadding(5)
    }
    
    /* requestNewUser
        requests that Parse creates a new user
    */
    func requestNewUser(email: String, username: String, password: String, pwRetyped: String) {
        if fieldsAreValid(email, username: username, password: password, pwRetyped: pwRetyped) {
            let newUser = PFUser()
            newUser.username = username
            newUser.email = email
            newUser.password = password
            setDefaultProfilePicture(newUser)
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

    /* fieldsAreValid
        checks if entered fields are valid input
    */
    func fieldsAreValid(email: String, username: String, password: String, pwRetyped: String) -> Bool {
        var isValid = true
        if isInvalidEmail(email) {
            print( EMAIL_INVALID)
            isValid = false
        }
        if isInvalidUsername(username) {
            if (isValid) {
                print(USERNAME_INVALID)
                isValid = false
            } else {
                print(MULTIPLE_INVALID)
            }
        }
        if isInvalidPassword(password) {
            if (isValid) {
                print( PASSWORD_INVALID)
                isValid = false
            } else {
                print(MULTIPLE_INVALID)
            }
        }
        if pwRetyped.isEmpty {
            print(MULTIPLE_INVALID)
            isValid = false
            return isValid
        }
        if password != pwRetyped {
            if (isValid) {
                print(PW_MISMATCH)
                isValid = false
            } else {
                print(MULTIPLE_INVALID)
            }
        }
        return isValid
    }

    /* registerSuccess
        actually registers user
    */
    func registerSuccess(user: PFUser) {
        setUserSession(user)
        let username = user.username
        print("Successfully added new user \(username!)")
    }

    /* handleError
        let us know if there is a parse error
    */
    func handleError(error: NSError?) {
        if let error = error {
            print("\(error)")
            if error.code == 202 {
                print(USERNAME_IN_USE)
            } else if error.code == 203 {
                print(EMAIL_IN_USE)
            } else {
                print(GENERIC_ERROR)
            }
        } else {
            print("nil error")
        }
    }
    
}
