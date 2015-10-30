//
//  Utils.swift
//  FlavorFinder
//
//  Created by Sudikoff Lab iMac on 10/27/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import Foundation
import UIKit

var USERNAME_CHAR_MAX = 50
var USERNAME_CHAR_MIN = 1
var PASSWORD_CHAR_MIN = 6
var PASSWORD_CHAR_MAX = 50

var backgroundColor_normal: UIColor!
var backgroundColor_error: UIColor = UIColor(red: 250/255.0, green: 126/255.0, blue: 107/255.0, alpha: 0.5)

// VALIDATION FUNCTIONS ------------------------------------------
func isInvalidEmail(email:String) -> Bool {
    let emailRegex = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
    return !emailTest.evaluateWithObject(email)
}

func isInvalidUsername(username: String) -> Bool {
    return (username.isEmpty ||
        username.characters.count > USERNAME_CHAR_MAX ||
        username.characters.count < USERNAME_CHAR_MIN)
}

func isInvalidPassword(password: String) -> Bool {
    return (password.isEmpty ||
        password.characters.count > PASSWORD_CHAR_MAX ||
        password.characters.count < PASSWORD_CHAR_MIN)}