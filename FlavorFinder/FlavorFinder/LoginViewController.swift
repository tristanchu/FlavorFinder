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
    
    // Keychain testing ----------------------------------------------
//    let MyKeychainWrapper = KeychainWrapper()
//    let createLoginButtonTag = 0
//    let loginButtonTag = 1


    // MARK: Properties -----------------------------------------------
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var loginUserTextField: UITextField!
    @IBOutlet weak var loginPassTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var goToTableButton: UIButton!
    
    var isValid: Bool = true
    
    // MARK: Segue Identifiers ----------------------------------------
    let loginToRegister = "segueLoginToRegister"
    let loginToMatchTable = "segueLoginToMatchTable"


    // MARK: Actions --------------------------------------------------
    // Login button
    @IBAction func loginActionBtn(sender: UIButton) {
        loginUser(loginUserTextField.text, password: loginPassTextField.text, msg: loginLabel)
    }
    
    // Register button - sends user to RegisterViewController page.
    @IBAction func goRegisterActionBtn(sender: UIButton) {
        self.performSegueWithIdentifier(loginToRegister, sender: self)
    }
    
    // Temporary button to go to main page without logging in
    @IBAction func goTableViewTEMP(sender: UIButton) {
        self.performSegueWithIdentifier(loginToMatchTable, sender: self)
    }
    
    
    // FUNCTIONS -------------------------------------------------------
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
    
    func loginUser(username: String!, password: String!, msg: UILabel!) {
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
                    // User exists - login and go to matches
                    msg.text = "User exists!"

                } else {
                    // User does not exist.
                    msg.text = "Incorrect username or password."
                }
            }
        } else {
            // Give alert if missing username or password fields:
            let alertView = UIAlertController(title: "Invalid Username or Password",
                message: "You must enter both a valid username and password." as String,
                preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return;
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.backgroundColor = backgroundColor_normal
    }
}
