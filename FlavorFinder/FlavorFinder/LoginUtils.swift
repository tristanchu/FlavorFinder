//
//  Utils.swift
//  FlavorFinder
//
//  Created by Jon on 10/27/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit

// Input validation values:
var USERNAME_CHAR_MAX = 50
var USERNAME_CHAR_MIN = 1
var PASSWORD_CHAR_MIN = 6
var PASSWORD_CHAR_MAX = 50

// Colors:
var backgroundColor_normal: UIColor!
var backgroundColor_error: UIColor = UIColor(red: 250/255.0, green: 126/255.0, blue: 107/255.0, alpha: 0.5)

// ----------------------------------------------------------------------
// SESSION VALIDATION FUNCTIONS ---------------------------------------
// ----------------------------------------------------------------------

/**
    isUserLoggedIn

    @return: Bool - True if user is currently logged into a session
*/
func isUserLoggedIn() -> Bool {
    return NSUserDefaults.standardUserDefaults().boolForKey(IS_LOGGED_IN_KEY)
}

/**
    setUserSession

    @param: username - String - validated, existing username
    @param: password - String - validated, existing password
*/
func setUserSession(username: String, password: String) -> Void {
    // Store username and password in keychain:
    MyKeychainWrapper.mySetObject(password, forKey: kSecValueData)
    MyKeychainWrapper.mySetObject(username, forKey: kSecAttrAccount)
    MyKeychainWrapper.writeToKeychain()
    
    // Store session bool in NSUserDefaults:
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: IS_LOGGED_IN_KEY)
    NSUserDefaults.standardUserDefaults().synchronize()
}

/**
    removeUserSession

    Removes username and password from Keychain by setting both to "default."
    Sets session bool to False. Called within Logout button.
*/
func removeUserSession() -> Void {
    // Remove Keychain data:
    MyKeychainWrapper.mySetObject("default", forKey: kSecValueData)
    MyKeychainWrapper.mySetObject("default", forKey: kSecAttrAccount)
    MyKeychainWrapper.writeToKeychain()
    // MyKeychainWrapper.resetKeychainItem() // <- why isn't this working?
    
    // Reset session bool
    NSUserDefaults.standardUserDefaults().setBool(false, forKey: IS_LOGGED_IN_KEY)
    NSUserDefaults.standardUserDefaults().synchronize()
}

/**
    getUsernameFromKeychain

    Gets username currently stored in the Keychain. If no user stored, gets
    the default username "default" as String.

    @return: username - String
*/
func getUsernameFromKeychain() -> String {
    return MyKeychainWrapper.myObjectForKey(kSecAttrAccount) as! String
}

/**
    getPasswordFromKeychain

    Gets password currently stored in the Keychain. If no user stored, gets
    the default password "default" as String.

    @return: password - String
*/
func getPasswordFromKeychain() -> String {
    return MyKeychainWrapper.myObjectForKey(kSecValueData) as! String
}

// ----------------------------------------------------------------------
// INPUT VALIDATION FUNCTIONS -------------------------------------------
// ----------------------------------------------------------------------

/**
    isInvalidEmail

    @param: email - String
    @return: True if email is not a valid email.
*/
func isInvalidEmail(email:String) -> Bool {
    let emailRegex = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
    return !emailTest.evaluateWithObject(email)
}

/**
    isInvalidUsername

    @param: username - String
    @return: True if username = empty, too long, or too short.
*/
func isInvalidUsername(username: String) -> Bool {
    return (username.isEmpty ||
        username.characters.count > USERNAME_CHAR_MAX ||
        username.characters.count < USERNAME_CHAR_MIN)
}

/**
    isInvalidPassword

    @param: password - String
    @return: True if password = empty, too long, or too short.
*/
func isInvalidPassword(password: String) -> Bool {
    return (password.isEmpty ||
        password.characters.count > PASSWORD_CHAR_MAX ||
        password.characters.count < PASSWORD_CHAR_MIN)}

// ----------------------------------------------------------------------
// ALERT FUNCTIONS ------------------------------------------------------
// ----------------------------------------------------------------------

/**
    loginAlertPopup

    Gives user an alert notification with the given text.

    @param: title - String - the Bolded text in the notification
    @param: msg - String - the non-bold text in the notificaiton
    @param: actionTitle - String - the button text
    @param: currController - UIViewController - the controller sending the alert.
*/
func loginAlertPopup(title: String, msg: String, actionTitle: String,
        currController: UIViewController) -> Void {

    let alertView = UIAlertController(title: title,
        message: msg,
        preferredStyle:.Alert)
    let okAction = UIAlertAction(title: actionTitle,
        style: .Default,
        handler: nil)
    alertView.addAction(okAction)
    currController.presentViewController(alertView,
        animated: true,
        completion: nil)
}

