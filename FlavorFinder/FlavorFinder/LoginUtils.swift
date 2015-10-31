//
//  Utils.swift
//  FlavorFinder
//
//  Created by Jon on 10/27/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit

var USERNAME_CHAR_MAX = 50
var USERNAME_CHAR_MIN = 1
var PASSWORD_CHAR_MIN = 6
var PASSWORD_CHAR_MAX = 50

var backgroundColor_normal: UIColor!
var backgroundColor_error: UIColor = UIColor(red: 250/255.0, green: 126/255.0, blue: 107/255.0, alpha: 0.5)

// VALIDATION FUNCTIONS ------------------------------------------

// isInvalidUsername
//
// @param: email - String
// @return: True if email is not a valid email.
func isInvalidEmail(email:String) -> Bool {
    let emailRegex = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
    return !emailTest.evaluateWithObject(email)
}

// isInvalidUsername
//
// @param: username - String
// @return: True if username = empty, too long, or too short.
func isInvalidUsername(username: String) -> Bool {
    return (username.isEmpty ||
        username.characters.count > USERNAME_CHAR_MAX ||
        username.characters.count < USERNAME_CHAR_MIN)
}

// isInvalidPassword
//
//  @param: password - String
//  @return: True if password = empty, too long, or too short.
func isInvalidPassword(password: String) -> Bool {
    return (password.isEmpty ||
        password.characters.count > PASSWORD_CHAR_MAX ||
        password.characters.count < PASSWORD_CHAR_MIN)}
