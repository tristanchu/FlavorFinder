//
//  RegisterView.swift
//  FlavorFinder
//
//  Handles the register view for within the container
//
//  Created by Courtney Ligh on 2/1/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit
import Parse

class RegisterView : UIViewController, UITextFieldDelegate {
    
    // MARK: Properties -----------------------------------

    // Text Labels:
    @IBOutlet weak var signUpPromptLabel: UILabel!
    @IBOutlet weak var warningTextLabel: UILabel!

    // Text Fields:
    @IBOutlet weak var usernameSignUpField: UITextField!
    @IBOutlet weak var pwSignUpField: UITextField!
    @IBOutlet weak var retypePwSignUpField: UITextField!
    @IBOutlet weak var emailSignUpField: UITextField!

    // Buttons (for UI)
    @IBOutlet weak var backToLoginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    let backBtnString =
        String.fontAwesomeIconWithName(.ChevronLeft) + " Back to login"

    // MARK: Actions -----------------------------------
    @IBAction func createAccountAction(sender: AnyObject) {
        print("clicked create account")
    }

    @IBAction func backToLoginAction(sender: AnyObject) {
        print("clicked back to login")
    }

    // MARK: Override Functions --------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set font awesome chevron:
        backToLoginButton.setTitle(backBtnString, forState: .Normal)
    }
    
    
}
