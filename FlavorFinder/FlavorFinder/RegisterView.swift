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
    
    // Navigation in containers (set during segue)
    var buttonSegue : String!
    
    // MARK: messages ------------------------------------
    // validation error messages
    let EMAIL_INVALID = "That doesn't look like an email!"
    let USERNAME_INVALID = "Usernames must be between \(USERNAME_CHAR_MIN) and \(USERNAME_CHAR_MAX) characters."
    let PASSWORD_INVALID = "Passwords must be between \(PASSWORD_CHAR_MIN) and \(PASSWORD_CHAR_MAX) characters."
    let PW_MISMATCH = "Passwords don't match!"
    let MULTIPLE_INVALID = "Please fix errors and resubmit."

    let OK_TEXT = "Ok"
    
    // request error messages
    let REQUEST_ERROR_TITLE = "Uhoh!"
    let GENERIC_ERROR = "Oops! An error occurred on the server. Please try again."
    let USERNAME_IN_USE = "That username is already in use. Please pick a new one!"
    let EMAIL_IN_USE = "Email already associated with an account!"

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
        if let parent = parentViewController as? ContainerViewController {
            parent.segueIdentifierReceivedFromParent(buttonSegue)
        }
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

        if isInvalidUsername(username) {
            alertUserBadInput(USERNAME_INVALID)
            return false
        }
        if isInvalidPassword(password) {
            alertUserBadInput(PASSWORD_INVALID)
            return false
        }
        if pwRetyped.isEmpty {
            alertUserBadInput(PW_MISMATCH)
            return false
        }
        if password != pwRetyped {
            alertUserBadInput(PW_MISMATCH)
            return false
        }
        if isInvalidEmail(email) {
            alertUserBadInput( EMAIL_INVALID)
            return false
        }
        return true
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
            // error - username already in use:
            if error.code == 202 {
                alertUserRegisterError(USERNAME_IN_USE)
            // error - email already in use
            } else if error.code == 203 {
                alertUserRegisterError(EMAIL_IN_USE)
            // error - generic error
            } else {
                alertUserRegisterError(GENERIC_ERROR)
            }
        } else {
            print("nil error")
        }
    }
    
    /* alertUserBadInput
        creates popup alert for when user submits bad input
        - helper function to make above code cleaner:
    */
    func alertUserBadInput(title: String) {
        alertPopup(title, msg: self.MULTIPLE_INVALID,
            actionTitle: self.OK_TEXT, currController: self)
    }
    
    /* alertUserRegisterError
        - helper function to create alert when parse rejects registration
    */
    func alertUserRegisterError(msg: String){
        alertPopup(self.REQUEST_ERROR_TITLE , msg: msg,
            actionTitle: self.OK_TEXT, currController: self)
    }
}
