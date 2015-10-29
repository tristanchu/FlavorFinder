//
//  LoginViewController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 10/22/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import Foundation
import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties -----------------------------------------------
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var loginUserTextField: UITextField!
    @IBOutlet weak var loginPassTextField: UITextField!
    
    var isValid: Bool = true
    
    // MARK: Segue Identifiers ----------------------------------------
    let loginToRegister = "segueLoginToRegister"
    let loginToMatchTable = "segueLoginToMatchTable"


    // MARK: Actions --------------------------------------------------
    @IBAction func loginActionBtn(sender: UIButton) {
        loginUser(loginUserTextField.text, password: loginPassTextField.text, msg: loginLabel)
    }
    
    // Send user to RegisterViewController page.
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
        self.navigationItem.hidesBackButton = true;
        backgroundColor_normal = loginUserTextField.backgroundColor!
        
        loginUserTextField.delegate = self
        loginPassTextField.delegate = self
        loginUserTextField.setTextLeftPadding(5)
        loginPassTextField.setTextLeftPadding(5)
        if let navi = self.navigationController as? MainNavigationController {
            navi.navigationItem.setLeftBarButtonItems([navi.goBackBtn, navi.searchBarActivateBtn], animated: true)
            navi.navigationItem.setRightBarButtonItems([navi.goForwardBtn, navi.menuBarBtn], animated: true)
            navi.dismissMenuTableView()
        }
    }
    
    func loginUser(username: String!, password: String!, msg: UILabel!) {
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
            msg.text = "Invalid username or password."
            isValid = true
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.backgroundColor = backgroundColor_normal
    }
}
