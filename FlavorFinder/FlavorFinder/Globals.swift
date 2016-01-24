//
//  Globals.swift
//  FlavorFinder
//
//  Created by Jon on 10/29/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit
import FontAwesome_swift

// Keychain wrapping:
let MyKeychainWrapper = KeychainWrapper()

// Keychain / NSUserDefaults keys:
let IS_LOGGED_IN_KEY = "isLoggedInKey"
let USERNAME_KEY = "username"

// Controller Identifiers:
let ProfileViewControllerIdentifier = "ProfileViewControllerIdentifier"
let MatchTableViewControllerIdentifier = "MatchTableViewControllerIdentifier"
let LoginViewControllerIdentifier = "LoginViewControllerIdentifier"

// DB Labels:
let TITLE_ALL_INGREDIENTS = "All Ingredients"
let CELLIDENTIFIER_MATCH = "MatchTableViewCell"
let CELLIDENTIFIER_MENU = "menuCell"

// Colors:
let LIGHTGRAY_COLOR = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: CGFloat(1))

let NAVI_BUTTON_COLOR = UIColor(red: 165/255.0, green: 242/255.0, blue: 216/255.0, alpha: CGFloat(1))
let NAVI_BUTTON_DARK_COLOR = UIColor(red: 135/255.0, green: 212/255.0, blue: 186/255.0, alpha: CGFloat(1))

let MATCH_LOW_COLOR = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
let MATCH_MEDIUM_COLOR = UIColor(red: 255/255.0, green: 237/255.0, blue: 105/255.0, alpha: CGFloat(0.3))
let MATCH_HIGH_COLOR = UIColor(red: 105/255.0, green: 230/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
let MATCH_GREATEST_COLOR = UIColor(red: 105/255.0, green: 255/255.0, blue: 150/255.0, alpha: CGFloat(0.3))

let NAVI_COLOR = UIColor(red: 121/255.0, green: 217/255.0, blue: 255/255.0, alpha: CGFloat(1))
let NAVI_LIGHT_COLOR = UIColor(red: 151/255.0, green: 224/255.0, blue: 252/255.0, alpha: CGFloat(1))

let HOTPOT_COLLECTION_COLOR = UIColor(red: 121/255.0, green: 217/255.0, blue: 255/255.0, alpha: CGFloat(0.3))

let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
