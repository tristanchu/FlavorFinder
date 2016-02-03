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
let MATCH_CELL_IMAGE_COLOR = UIColor.blackColor()

//let NAVI_BUTTON_COLOR = UIColor(red: 165/255.0, green: 242/255.0, blue: 216/255.0, alpha: CGFloat(1))
let NAVI_BUTTON_COLOR = UIColor(red: 131/255.0, green: 222/255.0, blue: 252/255.0, alpha: CGFloat(1))
let NAVI_BUTTON_DARK_COLOR = UIColor(red: 135/255.0, green: 212/255.0, blue: 186/255.0, alpha: CGFloat(1))

let MATCH_LOW_COLOR = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
let MATCH_MEDIUM_COLOR = UIColor(red: 255/255.0, green: 237/255.0, blue: 105/255.0, alpha: CGFloat(0.3))
let MATCH_HIGH_COLOR = UIColor(red: 105/255.0, green: 230/255.0, blue: 255/255.0, alpha: CGFloat(0.3))
let MATCH_GREATEST_COLOR = UIColor(red: 105/255.0, green: 255/255.0, blue: 150/255.0, alpha: CGFloat(0.3))
let MATCH_COLORS = [ // indices correspond to int match strength values
    MATCH_LOW_COLOR, // 0 index value ("no match" color/default color)
    MATCH_LOW_COLOR,
    MATCH_MEDIUM_COLOR,
    MATCH_HIGH_COLOR,
    MATCH_GREATEST_COLOR
]

//let NAVI_COLOR = UIColor(red: 121/255.0, green: 217/255.0, blue: 255/255.0, alpha: CGFloat(1))
let NAVI_COLOR = UIColor(red: 205/255.0, green: 239/255.0, blue: 250/255.0, alpha: CGFloat(1))
let NAVI_LIGHT_COLOR = UIColor(red: 151/255.0, green: 224/255.0, blue: 252/255.0, alpha: CGFloat(1))

let HOTPOT_COLLECTION_COLOR = UIColor(red: 121/255.0, green: 217/255.0, blue: 255/255.0, alpha: CGFloat(0.3))

let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!

// Filters:
let F_KOSHER = "kosher"
let F_DAIRY = "no dairy"
let F_VEG = "vegetarian"
let F_NUTS = "no nuts"

// Sizes:
let MATCH_CELL_IMAGE_SIZE = CGSizeMake(30, 30)
let UNIFORM_ROW_HEIGHT: CGFloat = 68.0  // for favs, lists, list details
let K_CELL_HEIGHT : CGFloat = 40.0

// Displayed error messages:
// --> "add it yourself" can be added when feature exists
let SEARCH_GENERIC_ERROR_TEXT = "There was an error with the search."
let INGREDIENT_NOT_FOUND_TEXT = "The ingredient you were looking for could not be found!"
let NO_MATCHES_TEXT = "No matches for this ingredient yet!"

// Displayed generic text:
let OK_TEXT = "Ok"