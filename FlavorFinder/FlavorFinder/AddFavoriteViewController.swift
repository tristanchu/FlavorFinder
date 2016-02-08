//
//  AddFavoriteViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 2/8/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//
//  Eventually, when we look to having add ingredient / add match capabilities,
//  we may want to abstract out some of this for a superclass since visually
//  these pages might be similar.
//

import Foundation
import Parse
import UIKit

class AddFavoriteViewController: UIViewController {
    
    /* viewDidAppear:
    Setup when user goes into page.
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("got it!")
        
        // Get navigation bar on top:
        if let navi = self.tabBarController?.navigationController
            as? MainNavigationController {
                for btn in (navi.tabBarController?.navigationItem.leftBarButtonItems)! {
                    btn.tintColor = NAVI_BUTTON_COLOR
                }
                self.tabBarController?.navigationItem.title = "Add A Favorite"
                navi.reset_navigationBar()
        }
    }
    
}