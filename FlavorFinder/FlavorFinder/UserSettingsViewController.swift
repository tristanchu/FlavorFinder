//
//  UserSettingsViewController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 11/5/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit

class UserSettingsViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties ------------------------------------------------
    @IBOutlet weak var userSettingsLabel: UILabel!


    // OVERRIDE FUNCTIONS ---------------------------------------------

    /**
    viewDidLoad  --override

    Sets visuals for navigation
    */
    override func viewDidLoad() {
        super.viewDidLoad()


        // Change page label to say "<User>'s Settings"
        userSettingsLabel.text = getUsernameFromKeychain() + "'s Settings"
    }
}
