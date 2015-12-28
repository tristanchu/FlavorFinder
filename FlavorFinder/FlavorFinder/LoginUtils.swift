//
//  Utils.swift
//  FlavorFinder
//
//  Created by Jon on 10/27/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit
import Parse

// Input validation values:
var USERNAME_CHAR_MAX = 50
var USERNAME_CHAR_MIN = 1
var PASSWORD_CHAR_MIN = 6
var PASSWORD_CHAR_MAX = 50

// Colors:
var backgroundColor_normal: UIColor!
var backgroundColor_error: UIColor = UIColor(red: 250/255.0, green: 126/255.0, blue: 107/255.0, alpha: 0.5)

var currentUser: PFUser?

// ----------------------------------------------------------------------
// SESSION VALIDATION FUNCTIONS ---------------------------------------
// ----------------------------------------------------------------------

/**
    isUserLoggedIn

    @return: Bool - True if user is currently logged into a session
*/
func isUserLoggedIn() -> Bool {
    return currentUser != nil
}

/**
    setUserSession

    @param: user - PFUser
*/
func setUserSession(user: PFUser) -> Void {
    // Store current PFUser
    currentUser = user
    getUserVotesFromCloud(user)
    getUserFavoritesFromCloud(user)
}

/**
    removeUserSession

    Removes stored PFUser
*/
func removeUserSession() -> Void {
    // remove stored PFUser:
    currentUser = nil
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
// KEYCHAIN FUNCTIONS ---------------------------------------------------
// ----------------------------------------------------------------------


// NOTE: Keeping Keychain functions for when we develop persistent data since
//       now we will need it when dealing with exiting and re-entering the app.

/**
storeLoginInKeychain

Stores current user's username and password in the Keychain

@param: user - PFUser
*/
func storeLoginInKeychain(username: String, password: String) -> Void {
    MyKeychainWrapper.mySetObject(password, forKey: kSecValueData)
    MyKeychainWrapper.mySetObject(username, forKey: kSecAttrAccount)
    MyKeychainWrapper.writeToKeychain()
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
