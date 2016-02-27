//
//  GotNaviViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 2/27/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//
//  For pages that interact with the top navigation controller
//  Setting the title text, for example
//

import Foundation
import UIKit

class GotNaviViewController : UIViewController {
    
    // MARK: Properties -----------------------------------------------------

    var navTitle : String?
    
    var backBtn: UIBarButtonItem = UIBarButtonItem()
    let backBtnAction = "backBtnClicked:"
    var backBtnString = String.fontAwesomeIconWithName(.ChevronLeft) + " Back" // default
    
    // MARK: Override Functions ---------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.navigationController?.viewControllers)
        if self.navigationController?.viewControllers.count > 1 {
            setUpBackButton()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Configure navigation bar on top:
        if let navi = self.tabBarController?.navigationController
            as? MainNavigationController {
                self.tabBarController?.navigationItem.setLeftBarButtonItems(
                    [backBtn], animated: true)
                self.tabBarController?.navigationItem.setRightBarButtonItems(
                    [], animated: true)
                navi.reset_navigationBar()
                if let _ = self.navTitle {
                    self.tabBarController?.navigationItem.title = "\(self.navTitle!)"
                }
                backBtn.enabled = true
        }
    }
    
    // MARK: Back Button Functions ------------------------------------------
    
    /* setUpBackButton
    - sets up the back button visuals for navigation
    */
    func setUpBackButton() {
        setUpNaviButton(backBtn, buttonString: backBtnString, target: self, action: "backBtnClicked")
    }
    
    /* backBtnClicked
    - action for back button: pop VC
    */
    func backBtnClicked() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
