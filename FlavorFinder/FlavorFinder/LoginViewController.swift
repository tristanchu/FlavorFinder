//
//  LoginViewController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 10/22/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginUserTextField: UITextField!
    @IBOutlet weak var loginPassTextField: UITextField!
    
    
    // MARK: Actions
    @IBAction func loginActionBtn(sender: UIButton) {
    }
    
    
    @IBAction func goRegisterActionBtn(sender: UIButton) {
        self.performSegueWithIdentifier("segueLoginToRegister", sender: self)
    }
    
    @IBAction func goTableViewTEMP(sender: UIButton) {
        self.performSegueWithIdentifier("segueLoginToMatchTable", sender: self)
    }
    
    
    
}
