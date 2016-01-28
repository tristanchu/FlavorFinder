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
    
    let segueLoginEmbedded = "segueLoginEmbedSubview"
    let segueToLogin = "goToLogin"
    let segueToRegister = "goToRegister"
    
    var debugLoggedIn = false
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if debugLoggedIn {
            containerVC?.view.hidden = true
        } else {
            containerVC?.view.hidden = false
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