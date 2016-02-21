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

class SettingsPage : ContainerParentViewController {
    
    // MARK: Properties: --------------------------------------------------
    // Labels:
    @IBOutlet weak var pagePromptLabel: UILabel!
    @IBOutlet weak var passwordSentLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    var loggedOutMessage : UILabel?
    
    // Text:
    let pageTitle = "Settings"
    let loggedOutText = "You must be logged in to have settings."
    
    // Placement:
    let loggedOutPlacementHeightMultiplier : CGFloat = 0.25
    
    // Segues:
    let segueToLogin = "goToLogin"
    let segueToRegister = "goToRegister"
    let segueLoginEmbedded = "embedSettingsToLogin"

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
    
    /* viewDidLoad:
    - Setup when view is loaded into memory
    */
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /* viewDidAppear:
    - Setup when user goes into page.
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
        // move message up to make room
        loggedOutMessage?.frame.size.height = self.view.frame.size.height * loggedOutPlacementHeightMultiplier
        self.view.addSubview(loggedOutMessage!)
        
        setUpLoginContainerUI()
        print(containerVC)

        if currentUser != nil {
            displayLoggedIn()
        } else {
            displayLoggedOut()
        }
    }
    
    /* prepareForSegue:
    - setup before seguing
    - prior to container's embed segue, will set up parent class variable to have
        access to contained VC
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if self.segueEmbeddedContent == nil {
            self.setValue(segueLoginEmbedded, forKey: "segueEmbeddedContent")
        }
        super.prepareForSegue(segue, sender: sender)
    }
    
    // MARK: Other functions -------------------------------------------------
    /* displayLoggedIn
    - hides or unhides subviews for the logged-in display
    */
    func displayLoggedIn() {
        // Logged-in UI
        logoutButton.hidden = false
        resetPasswordButton.hidden = false
        passwordSentLabel.hidden = true
        pagePromptLabel.hidden = false
        
        // Logged-out UI
        loggedOutMessage?.hidden = true
        containerVC?.view.hidden = true // embedded login module
    }
    
    /* displayLoggedOut
    - hides or unhides subviews for the logged-out display
    */
    func displayLoggedOut() {
        // Logged-in UI
        logoutButton.hidden = true
        resetPasswordButton.hidden = true
        passwordSentLabel.hidden = true
        pagePromptLabel.hidden = true
        
        // Logged-out UI
        loggedOutMessage?.hidden = false
        containerVC?.view.hidden = false // embedded login module
        goToLogin()
    }
    
    func goToLogin() {
        containerVC?.segueIdentifierReceivedFromParent(segueToLogin)
        print("attempted to go to login")
    }
    
    func goToRegister() {
        containerVC?.segueIdentifierReceivedFromParent(segueToRegister)
    }
    
    /* setUpLoginContainerUI
    - login / register container UI
    */
    func setUpLoginContainerUI() {
        // Rounded edges for container:
        containerVC?.view.layer.cornerRadius = 20
        containerVC?.view.clipsToBounds = true
    }

}
