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

// Filters:
let F_KOSHER = "kosher"
let F_DAIRY = "no dairy"
let F_VEG = "vegetarian"
let F_NUTS = "no nuts"

// Colors:
let LIGHTGRAY_COLOR = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: CGFloat(1))

let MATCH_CELL_IMAGE_COLOR = UIColor.blackColor()

let NAVI_COLOR = UIColor(red: 205/255.0, green: 239/255.0, blue: 250/255.0, alpha: CGFloat(1))
let NAVI_LIGHT_COLOR = UIColor(red: 151/255.0, green: 224/255.0, blue: 252/255.0, alpha: CGFloat(1))
let NAVI_BUTTON_COLOR = UIColor(red: 51/255.0, green: 202/255.0, blue: 252/255.0, alpha: CGFloat(1))
let NAVI_BUTTON_DARK_COLOR = UIColor(red: 135/255.0, green: 212/255.0, blue: 186/255.0, alpha: CGFloat(1))

let SEARCH_RESULTS_CELL_COLOR = UIColor.whiteColor()
let FAV_CELL_BTN_COLOR = UIColor(red: 249/255.0, green: 181/255.0, blue: 255/255.0, alpha: CGFloat(1))
let DOWNVOTE_CELL_BTN_COLOR = UIColor(red: 252/255.0, green: 200/255.0, blue: 183/255.0, alpha: CGFloat(1))
let UPVOTE_CELL_BTN_COLOR = UIColor(red: 185/255.0, green: 250/255.0, blue: 177/255.0, alpha: CGFloat(1))
let ADD_TO_SEARCH_CELL_BTN_COLOR = UIColor(red: 218/255.0, green: 239/255.0, blue: 247/255.0, alpha: CGFloat(1))
let ADD_TO_LIST_CELL_BTN_COLOR = UIColor(red: 247/255.0, green: 246/255.0, blue: 218/255.0, alpha: CGFloat(1))
let CELL_BTN_OFF_COLOR = UIColor.grayColor()
let CELL_BTN_ON_COLOR = UIColor.blackColor()

let HOTPOT_COLLECTION_COLOR = UIColor(red: 121/255.0, green: 217/255.0, blue: 255/255.0, alpha: CGFloat(0.3))

let EMPTY_SET_TEXT_COLOR = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)


// Fonts:
let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(15)] as Dictionary!

// Sizes:
let MATCH_CELL_IMAGE_SIZE = CGSizeMake(30, 30)
let UNIFORM_ROW_HEIGHT: CGFloat = 68.0  // for favs, lists, list details
let K_CELL_HEIGHT : CGFloat = 40.0

// Displayed error messages:
// --> "add it yourself" can be added when feature exists
let SEARCH_GENERIC_ERROR_TEXT = "There was an error with the search."
let MATCHES_NOT_FOUND_TEXT = "No matches for this search!"

// Displayed generic text:
let OK_TEXT = "Ok"
