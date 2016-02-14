//
//  SettingsPage.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 2/10/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit
import Parse

class SettingsPage : UIViewController {
    
  
    // MARK: Properties:
    // Labels:
    @IBOutlet weak var pagePromptLabel: UILabel!
    @IBOutlet weak var passwordSentLabel: UILabel!
    @IBOutlet weak var notLoggedInLabel: UILabel!
    let pageTitle = "Settings"

    // Buttons:
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    // Button actions:
    @IBAction func resetPasswordBtn(sender: UIButton) {
        passwordSentLabel.hidden = false
        // Commented out because it actually sents an email:
//        requestPasswordReset()
    }

    @IBAction func logoutBtn(sender: UIButton) {
        if currentUser != nil {
            PFUser.logOutInBackground()
            currentUser = nil
            // Change view to no user view:
            logoutButton.hidden = true
            resetPasswordButton.hidden = true
            notLoggedInLabel.hidden = false
            passwordSentLabel.hidden = true
            pagePromptLabel.hidden = true
        }
    }


    // MARK: Override methods: ----------------------------------------------
    /* viewDidLoad:
    Additional setup after loading the view (upon open)
    */
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /* viewDidAppear:
    Setup when user goes into page.
    */
    override func viewDidAppear(animated: Bool) {
        // Get navigation bar on top:
        if let navi = self.tabBarController?.navigationController
            as? MainNavigationController {
                self.tabBarController?.navigationItem.setLeftBarButtonItems(
                    [], animated: true)
                self.tabBarController?.navigationItem.setRightBarButtonItems(
                    [], animated: true)
                navi.reset_navigationBar()
                
                self.tabBarController?.navigationItem.title = pageTitle
        }
        super.viewDidAppear(animated)

        if currentUser != nil {
            logoutButton.hidden = false
            resetPasswordButton.hidden = false
            notLoggedInLabel.hidden = true
            passwordSentLabel.hidden = true
            pagePromptLabel.hidden = false
        } else {
           logoutButton.hidden = true
            resetPasswordButton.hidden = true
            notLoggedInLabel.hidden = false
            passwordSentLabel.hidden = true
            pagePromptLabel.hidden = true
        }
    }

}
