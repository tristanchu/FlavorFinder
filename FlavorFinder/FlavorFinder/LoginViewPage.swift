//
//  LoginViewPage.swift
//  FlavorFinder
//
//  Handles the login view
//
//  Created by Courtney Ligh on 2/1/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit
import Parse

class LoginViewPage : UIViewController, UITextFieldDelegate {

    // Navigation in containers (set during segue)
    var buttonSegue : String!

    // MARK: Properties
    @IBOutlet weak var loginPromptLabel: UILabel!
    var isValid: Bool = true

    // Text fields:
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    // Buttons:
    @IBOutlet weak var loginButton:UIButton!
    @IBOutlet weak var sigupUpButton: UIButton!

    // Pop up text:
    let INCORRECT_U_OR_P_TITLE = "Incorrect Username or Password"
    let INCORRECT_U_OR_P_MSG = "Username and Password do not match."

    let INVALID_TITLE = "Invalid Username or Password"
    let INVALID_MSG = "You must enter a valid username and password."
    
    // Toast Text:
    let LOGGED_IN_MESSAGE = "Logged in as " // + username dynamically


// MARK: Actions --------------------------------------------------
    // Login button:
    @IBAction func loginButtonAction(sender: UIButton) {
        loginUser(usernameField.text, password: passwordField.text)
    }

    // Sign up button:
    @IBAction func signUpButtonAction(sender: UIButton) {
        if let parent = parentViewController as? ContainerViewController {
            parent.segueIdentifierReceivedFromParent(buttonSegue)
        }
    }

// OVERRIDE FUNCTIONS ---------------------------------------------
    /**
    viewDidLoad

    Controls visuals upon loading view.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

        usernameField.delegate = self
        passwordField.delegate = self
        usernameField.setTextLeftPadding(5)
        passwordField.setTextLeftPadding(5)
        
        // button visuals:
        setDefaultButtonUI(loginButton)
        setSecondaryButtonUI(sigupUpButton)
    }

    /*
    viewDidAppear

    runs when view appears
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    /**
    loginUser

    Checks input for user and pw fields as valid strings, authenticates
    using Parse, then logs in user if successful.

    @param: username - String! - string given in username input field
    @param: password - String! - string given in password input field
    */
    func loginUser(username: String!, password: String!) {
        // Default to true:
        isValid = true

        // Validate username and password input:
        if isInvalidUsername(username) {
            usernameField.backgroundColor = backgroundColor_error
            isValid = false
        }
        if isInvalidPassword(password) {
            passwordField.backgroundColor = backgroundColor_error
            isValid = false
        }
        if isValid {
            // Authenticate user with Parse
            PFUser.logInWithUsernameInBackground(
                username!, password: password!) {
                    (user: PFUser?, error: NSError?) -> Void in

                    if user != nil {
                        // User exists - set user session
                        setUserSession(user!)
                        if let parentVC = self.parentViewController?.parentViewController as! LoginModuleParentViewController? {
                            parentVC.loginSucceeded()
                            // Test Toast:
                            let loginMsg = self.LOGGED_IN_MESSAGE + "\(username)"
                            parentVC.view.makeToast(loginMsg, duration: TOAST_DURATION, position: .Bottom)
                            print("SUCCESS: logged in")
                        } else {
                            print("ERROR: could not find user")
                        }
                    } else {
                        // Alert Username and Password pair does not exist.
                        alertPopup(self.INCORRECT_U_OR_P_TITLE,
                            msg: self.INCORRECT_U_OR_P_MSG as String,
                            actionTitle: OK_TEXT,
                            currController: self)
                        print("ERROR: username and password pair do not exist")
                    }
            }
        } else {
            // Alert missing username or password fields:
            alertPopup(self.INVALID_TITLE,
                msg: self.INVALID_MSG as String,
                actionTitle: OK_TEXT,
                currController: self)
        }
    }

}