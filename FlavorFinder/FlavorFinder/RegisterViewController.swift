//
//  RegisterViewController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 10/24/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import Foundation
import UIKit


class RegisterViewController: UIViewController {
    
    @IBOutlet weak var RegisterLabel: UILabel!
    @IBOutlet weak var RegisterEmail: UITextField!
    @IBOutlet weak var RegisterPassword: UITextField!
    @IBOutlet weak var RegisterCOPPA: UILabel!
    @IBOutlet weak var RegisterSubmitBtn: UIButton!
    //// somewhere we need a privacy policy :)
    
    func requestNewUser() {
     /// here, send new parse request for new user credentials
    }
    
    func registerSuccess() {
        //// success!
    }
    
}
