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

// TOAST:
let TOAST_DURATION = 1.0

// Colors:
let LIGHTGRAY_COLOR = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: CGFloat(1))

let MATCH_CELL_IMAGE_COLOR = UIColor.blackColor()

let NAVI_COLOR = UIColor(red: 205/255.0, green: 239/255.0, blue: 250/255.0, alpha: CGFloat(1))
let NAVI_LIGHT_COLOR = UIColor(red: 151/255.0, green: 224/255.0, blue: 252/255.0, alpha: CGFloat(1))
let NAVI_BUTTON_COLOR = UIColor.whiteColor()
// UIColor(red: 51/255.0, green: 202/255.0, blue: 252/255.0, alpha: CGFloat(1))
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

let EMPTY_SET_TEXT_COLOR  = UIColor.darkGrayColor()
//let EMPTY_SET_TEXT_COLOR = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)


// Fonts:
let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(15)] as Dictionary!
let CELL_FONT_AWESOME = UIFont.fontAwesomeOfSize(16)
let CELL_FONT = UIFont(name: "Avenir Next Medium", size: 17)
let FILTER_BUTTON_FONT =  UIFont(name: "Avenir Next Medium", size: 15)

let EMPTY_SET_FONT = UIFont(name: "Avenir Next Regular", size: 15)

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

// Search Bar Formattng:
let ROUNDED_SIZE : CGFloat = 15.0       // searchbar.layer.cornerRadius = 15
let ROUNDED_EDGES = true    // searchbar.clipsToBounds = true

// Button formatting ---------------------------:
// Use setDefaultButtonUI() For these settings:
let DEFAULT_BUTTON_BORDER_WIDTH : CGFloat = 2.0
let DEFAULT_BUTTON_BORDER_COLOR : CGColorRef = UIColor.lightGrayColor().CGColor
let DEFAULT_BUTTON_FONT_COLOR : UIColor = UIColor.darkGrayColor()

// Use setSecondaryButtonUI() for these settings:
let SECONDARY_BUTTON_BORDER_WIDTH : CGFloat = 1.0
let SECONDARY_BUTTON_BORDER_COLOR : CGColorRef = UIColor.lightGrayColor().CGColor
let SECONDARY_BUTTON_FONT_COLOR : UIColor = UIColor.darkGrayColor()


let ROUNDED_BUTTON_SIZE : CGFloat = 10.0

// STORYBOARD STYLE GUIDE:

    // StackViews with Prompts - make top 60 from Top Layout Guide.bottom
    // Text
        // - font = Anvier Next
                // - page prompt = medium
                // -
        // - color = Dark Grey
        // - size = (page prompt - 22

    // Buttons ->
        // Login - font size = 20
        // All other buttons - font size = 15
                            // font = Anvier next
                            //    - primary = medium
                            //    - secondary = regular
                            // padding - 5 on all sides
                            //      -- OR - make stack view width of
                            //              text bar nad have buttons
                            //              fill equally with 20 spacing
    // Search bars:
        // - width = 0.8 of superview
        // - height =


