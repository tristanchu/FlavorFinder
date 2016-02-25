//
//  LoginModuleParentViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 2/21/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//
//  Prototype class for ContainerParentViewController parents of
//  contained login/register module.
//

import Foundation
import UIKit


class LoginModuleParentViewController : ContainerParentViewController {
    
    // MARK: Properties: --------------------------------------------------

    // Segues:
    let segueToLogin = "goToLogin"
    let segueToRegister = "goToRegister"
    
    // MARK: Login module nav functions -----------------------------------

    func goToLogin() {
        containerVC?.segueIdentifierReceivedFromParent(segueToLogin)
    }
    
    func goToRegister() {
        containerVC?.segueIdentifierReceivedFromParent(segueToRegister)
    }
    
    // MARK: Login module UI functions ------------------------------------

    /* setUpLoginContainerUI
    - login / register container UI
    */
    func setUpLoginContainerUI() {
        // Rounded edges for container:
        containerVC?.view.layer.cornerRadius = 20
        containerVC?.view.clipsToBounds = true
    }
    
    // MARK: Login response functions -------------------------------------
    
    /* loginSucceeded
    - response to successful login
    - hides contained view
    */
    func loginSucceeded() {
        containerVC?.view.hidden = true
    }

}