//
//  NewSearchViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 1/13/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//
//  Handles search bar interaction on the new search state of the landing page.
//  Also handles logged in logic to determine whether or not to display login/register container.
//

import Foundation
import UIKit
import Parse

class NewSearchViewController : ContainerParentViewController {
    
    // MARK: Properties:

    // Identifiers from storyboard: (note, constraints on there)
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appIconView: UIImageView!
    @IBOutlet weak var searchPrompt: UILabel!
    @IBOutlet weak var newSearchBar: UISearchBar!
    @IBOutlet weak var newSearchSearchBar: UISearchBar!


    // Segues:
    let segueLoginEmbedded = "segueLoginEmbedSubview"
    let segueToLogin = "goToLogin"
    let segueToRegister = "goToRegister"

    // Testing:
    var debugLoggedIn = false

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Rounded edges for search bar:
        self.newSearchBar.layer.cornerRadius = 15
        self.newSearchBar.clipsToBounds = true

        // Hide/Show login container based on if user is logged in:
        if currentUser != nil {
            containerVC?.view.hidden = true
        } else {
            containerVC?.view.hidden = false
            
            // Rounded edges for container:
            containerVC?.view.layer.cornerRadius = 20
            containerVC?.view.clipsToBounds = true
            goToLogin()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if self.segueEmbeddedContent == nil {
            self.setValue(segueLoginEmbedded, forKey: "segueEmbeddedContent")
        }
        super.prepareForSegue(segue, sender: sender)
    }
    
    func goToLogin() {
        containerVC?.segueIdentifierReceivedFromParent(segueToLogin)
    }
    
    func goToRegister() {
        containerVC?.segueIdentifierReceivedFromParent(segueToRegister)
    }
    
}