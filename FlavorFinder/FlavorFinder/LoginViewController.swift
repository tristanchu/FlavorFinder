//
//  LoginViewController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 10/22/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties -----------------------------------------------
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var loginUserTextField: UITextField!
    @IBOutlet weak var loginPassTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    // Debug:
    @IBOutlet weak var goToTableButton: UIButton!
    
    var isValid: Bool = true
    
    // MARK: Segue Identifiers ----------------------------------------
    let loginToRegister = "segueLoginToRegister"
    let loginToMatchTable = "segueLoginToMatchTable"

    // MARK: Actions --------------------------------------------------
    // Login button
    @IBAction func loginActionBtn(sender: UIButton) {
        loginUser(loginUserTextField.text, password: loginPassTextField.text)
    }
    
    // Register button - sends user to RegisterViewController page.
    @IBAction func goRegisterActionBtn(sender: UIButton) {
        self.performSegueWithIdentifier(loginToRegister, sender: self)
    }
    
    // DEBUG: Temporary button to go to main page without logging in
    @IBAction func goTableViewTEMP(sender: UIButton) {
        self.performSegueWithIdentifier(loginToMatchTable, sender: self)
    }
    
    // OVERRIDE FUNCTIONS ---------------------------------------------

    /**
    viewDidLoad
    
    Controls visuals upon loading view.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        backgroundColor_normal = loginUserTextField.backgroundColor!
        
        loginUserTextField.delegate = self
        loginPassTextField.delegate = self
        loginUserTextField.setTextLeftPadding(5)
        loginPassTextField.setTextLeftPadding(5)
        
        if let navi = self.navigationController as? MainNavigationController {
            navi.navigationItem.setLeftBarButtonItems([], animated: true)
            navi.navigationItem.setRightBarButtonItems([], animated: true)
            navi.reset_navigationBar()
        }
    }
    
    /**
    textFieldDidBeginEditing

    Sets textField background color to "normal" color.
    */
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.backgroundColor = backgroundColor_normal
    }

    // FUNCTIONS -------------------------------------------------------

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
            loginUserTextField.backgroundColor = backgroundColor_error
            isValid = false
        }
        if isInvalidPassword(password) {
            loginPassTextField.backgroundColor = backgroundColor_error
            isValid = false
        }
        if isValid {
            // Authenticate user with Parse
            PFUser.logInWithUsernameInBackground(
                    username!, password: password!) {
                (user: PFUser?, error: NSError?) -> Void in

                if user != nil {
                    // User exists - set user session & go to Match Table
                    setUserSession(username, password: password)
                    self.performSegueWithIdentifier(self.loginToMatchTable,
                        sender: self)

                } else {
                    // Alert Username and Password pair does not exist.
                    alertPopup("Incorrect Username or Password",
                        msg: "Username and Password do not match." as String,
                        actionTitle: "Ok",
                        currController: self)
                }
            }
        } else {
            // Alert missing username or password fields:
            alertPopup("Invalid Username or Password",
                msg: "You must enter a valid username and password." as String,
                actionTitle: "Ok",
                currController: self)
        }
    }

}
