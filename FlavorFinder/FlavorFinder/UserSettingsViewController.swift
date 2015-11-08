//
//  UserSettingsViewController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 11/5/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit

class UserSettingsViewController: UIViewController, UITextFieldDelegate {

    // MARK: Attributes ------------------------------------------------
    let TITLE_USER_SETTINGS_PAGE = "Settings"
    
    // MARK: Properties ------------------------------------------------
    @IBOutlet weak var userSettingsLabel: UILabel!
    @IBOutlet weak var changePasswordLabel: UILabel!

    @IBOutlet weak var currPasswordField: UITextField!
    @IBOutlet weak var newPasswordOneField: UITextField!
    @IBOutlet weak var newPasswordTwoField: UITextField!


    // MARK: Actions -----------------------------------------------

    @IBAction func setNewPasswordAction(sender: UIButton) {
        resetPassword(currPasswordField,
            newPW1: newPasswordOneField,
            newPW2: newPasswordTwoField)
    }


    // OVERRIDE FUNCTIONS ---------------------------------------------

    /**
    viewDidLoad  --override

    Sets visuals for navigation
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Text field stuff:
        backgroundColor_normal = currPasswordField.backgroundColor!
        currPasswordField.delegate = self
        newPasswordOneField.delegate = self
        newPasswordTwoField.delegate = self

        // Display "Profile" in navigation bar
        if let navi = self.navigationController as? MainNavigationController {
            navi.navigationItem.setLeftBarButtonItems([], animated: true)
            navi.navigationItem.setRightBarButtonItems([navi.menuBarBtn], animated: true)
            navi.reset_navigationBar()
            navi.navigationItem.title = TITLE_USER_SETTINGS_PAGE
        }
        
        // Change page label to say "<User>'s Settings"
        userSettingsLabel.text = getUsernameFromKeychain() + "'s Settings"
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
    resetPassword

    validates password input, checks against current saved password, updates
    new password to both parse and keychain.
    */
    func resetPassword(currPW: UITextField, newPW1: UITextField, newPW2: UITextField) {
        // Default to true
        var isValidInput = true

        // Check that fields are not empty and new password is in length range:
        if currPW.text!.isEmpty {
            currPW.backgroundColor = backgroundColor_error
            isValidInput = false
        }
        if isInvalidPassword(newPW1.text!){
            newPW1.backgroundColor = backgroundColor_error
            isValidInput = false
        }
        if isInvalidPassword(newPW2.text!){
            newPW2.backgroundColor = backgroundColor_error
            isValidInput = false
        }

        if isValidInput {
            // User entered valid input; proceed:
            print("got valid input. currPW", currPW.text!, "new1:", newPW1.text!, "new2:", newPW2.text!)
        }
        else {
            // Missing a field, tell them:
            alertPopup("Missing fields",
                msg: "Must fill in password fields",
                actionTitle: "Ok",
                currController: self)
        }
    }


}
