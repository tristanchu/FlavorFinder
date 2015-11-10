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
    
    // MARK: Error Messages --------------------------------------------
    let PASSWORD_INVALID_TITLE = "Invalid password input"
    let PASSWORD_INVALID_MSG = "Passwords must be between \(PASSWORD_CHAR_MIN) and \(PASSWORD_CHAR_MAX) characters."

    let NEW_PASSWORD_MISMATCH_TITLE = "New password entries do not match"
    let NEW_PASSWORD_MISMATCH_MSG = "New password entries must match."

    let CURR_PASSWORD_WRONG_TITLE = "Current password not found."
    let CURR_PASSWORD_WRONG_MSG = "Please re-enter your current password"

    let OK_BUTTON = "Ok"

    // MARK: Properties ------------------------------------------------
    @IBOutlet weak var userSettingsLabel: UILabel!
    @IBOutlet weak var changePasswordLabel: UILabel!

    @IBOutlet weak var currPasswordField: UITextField!
    @IBOutlet weak var newPasswordOneField: UITextField!
    @IBOutlet weak var newPasswordTwoField: UITextField!


    // MARK: Actions -----------------------------------------------

    @IBAction func setNewPasswordAction(sender: UIButton) {
        let currPW = currPasswordField.text
        let newPW1 = newPasswordOneField.text
        let newPW2 = newPasswordTwoField.text
        print("pressed Reset password with \(currPW!), \(newPW1!), \(newPW2!)")
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
        userSettingsLabel.text = "\(currentUser!.username!)'s Settings"
    }

    /**
    textFieldDidBeginEditing

    Sets textField background color to "normal" color.
    */
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.backgroundColor = backgroundColor_normal
    }

    // FUNCTIONS -------------------------------------------------------

}
