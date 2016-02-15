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
    var loggedOutMessage : UILabel?
    
    // Text:
    let pageTitle = "Settings"
    let loggedOutText = "You must be logged in to have settings."

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
            displayLoggedOut()
        }
    }

    // MARK: Override methods: ----------------------------------------------

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
        
        if let _ = loggedOutMessage { // avoid stacking labels
            loggedOutMessage?.hidden = true
            loggedOutMessage?.removeFromSuperview()
        }
        loggedOutMessage = emptyBackgroundText(loggedOutText, view: self.view)
        self.view.addSubview(loggedOutMessage!)

        if currentUser != nil {
            displayLoggedIn()
        } else {
            displayLoggedOut()
        }
    }
    
    // MARK: Other functions
    /* displayLoggedIn
    */
    func displayLoggedIn() {
        // Logged-in UI
        logoutButton.hidden = false
        resetPasswordButton.hidden = false
        passwordSentLabel.hidden = true
        pagePromptLabel.hidden = false
        
        // Logged-out UI
        self.loggedOutMessage?.hidden = true
        print(self.loggedOutMessage?.hidden)
    }
    
    /* displayLoggedOut
    */
    func displayLoggedOut() {
        // Logged-in UI
        logoutButton.hidden = true
        resetPasswordButton.hidden = true
        passwordSentLabel.hidden = true
        pagePromptLabel.hidden = true
        
        // Logged-out UI
        self.loggedOutMessage?.hidden = false
    }

}
