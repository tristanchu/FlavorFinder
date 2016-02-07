//
//  EditListPage.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 2/7/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit
import Parse

class EditListPage: UIViewController {
    
    // MARK: Properties:
    var ingredientList = [PFIngredient]()
    var userListObject: PFList!
    
    // Visual related:
    let pageTitle = "Edit List"
    var listTitle = ""
    
    
    // Navigation:
    var backBtn: UIBarButtonItem = UIBarButtonItem()
    let backBtnAction = "backBtnClicked:"
    let backBtnString = String.fontAwesomeIconWithName(.ChevronLeft) + " Back"
    
    // MARK: Override methods: ----------------------------------------------
    
    
    /* viewDidLoad:
    Additional setup after loading the view (upon open)
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation buttons:
        setUpBackButton()
    }
    
    /* viewDidAppear:
    Setup when user goes into page.
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Get navigation bar on top:
        if let navi = self.tabBarController?.navigationController
            as? MainNavigationController {
                self.tabBarController?.navigationItem.setLeftBarButtonItems(
                    [self.backBtn], animated: true)
                self.tabBarController?.navigationItem.setRightBarButtonItems(
                    [], animated: true)
                navi.reset_navigationBar()
                self.tabBarController?.navigationItem.title = "\(self.listTitle)"
                self.backBtn.enabled = true
        }
    }
    
    // MARK: Back Button Functions -----------------------------------------
    
    
    /* setUpBackButton
    sets up the back button visuals for navigation
    */
    func setUpBackButton() {
        backBtn.setTitleTextAttributes(attributes, forState: .Normal)
        backBtn.title = self.backBtnString
        backBtn.tintColor = NAVI_BUTTON_COLOR
        backBtn.target = self
        backBtn.action = "backBtnClicked"  // refers to: backBtnClicked()
    }
    
    /* backBtnClicked
    - action for back button
    */
    func backBtnClicked() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    
}