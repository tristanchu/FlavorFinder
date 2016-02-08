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
    
    /* viewDidLoad:
    */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /* viewDidAppear:
    Setup when user goes into page.
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Get navigation bar on top:
        if let navi = self.tabBarController?.navigationController
            as? MainNavigationController {
                print("got it") // we are not getting it
                for btn in (navi.tabBarController?.navigationItem.leftBarButtonItems)! {
                    btn.tintColor = NAVI_BUTTON_COLOR
                }
                navi.reset_navigationBar()
        }
    }
    
}