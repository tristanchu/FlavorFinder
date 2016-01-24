//
//  MorePageController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 1/10/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit
import Parse

class MorePageController: UIViewController, UITextFieldDelegate {


    // FOR TEST PURPOSESONLY!!!
    @IBOutlet weak var morePageLabel: UILabel!
    @IBAction func loginTestUser(sender: AnyObject) {
        let username = "testUser";
        let password = "testUser";
        // Authenticate user with Parse
        PFUser.logInWithUsernameInBackground(
            username, password: password) {
                (user: PFUser?, error: NSError?) -> Void in

                if user != nil {
                    // User exists - set user session & go to Match Table
                    setUserSession(user!)

                    // Show on more page:
                    self.morePageLabel.text = currentUser?.username;
                }
        }
    }

}
