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
    let IncorrectUorPTitle = "Incorrect Username or Password"
    let IncorrectUorPMsg = "Username and Password do not match."
    let OKText = "Ok"

    let InvalidUorPTitle = "Invalid Username or Password"
    let InvalidUorPMsg = "You must enter a valid username and password."


// MARK: Actions --------------------------------------------------
    // Login button:
    @IBAction func loginButtonAction(sender: UIButton) {
        loginUser(usernameField.text, password: passwordField.text)
    }

    // Sign up button:
    @IBAction func signUpButtonAction(sender: UIButton) {
        print("pressed sign up")
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
                        // User exists - set user session & go to Match Table
                        setUserSession(user!)

                    } else {
                        // Alert Username and Password pair does not exist.
                        alertPopup(self.IncorrectUorPTitle,
                            msg: self.IncorrectUorPMsg as String,
                            actionTitle: self.OKText,
                            currController: self)
                    }
            }
        } else {
            // Alert missing username or password fields:
            alertPopup(self.InvalidUorPTitle,
                msg: self.InvalidUorPMsg as String,
                actionTitle: self.OKText,
                currController: self)
        }
    }

}