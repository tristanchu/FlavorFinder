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


    // OVERRIDE FUNCTIONS ---------------------------------------------

    /**
    viewDidLoad  --override

    Sets visuals for navigation
    */
    override func viewDidLoad() {
        super.viewDidLoad()

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
}
