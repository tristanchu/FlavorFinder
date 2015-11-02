//
//  ProfileViewController.swift
//  FlavorFinder
//
//  Created by Jon on 10/26/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    let TITLE_PROFILE_PAGE = "Profile"
    var savedMatchIds: [Int] = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        if let navi = self.navigationController as? MainNavigationController {
            navi.navigationItem.setLeftBarButtonItems([], animated: true)
            navi.navigationItem.setRightBarButtonItems([navi.menuBarBtn], animated: true)
            navi.reset_navigationBar()
            navi.navigationItem.title = TITLE_PROFILE_PAGE
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidAppear(animated: Bool) {
        // if view revisted in app, load again
        self.loadContent()
        super.viewDidAppear(animated)
    }
    
    func loadContent() {
        /// need offline vs online options
        loadUserData() /// might be from cached source
        loadSavedMatches()
    }
    
    func loadUserData() {
        ///
    }
    
    func loadSavedMatches() { // a.k.a. load favorites
        //// NSUserDefaults to cache favorites for offline recall too?
        savedMatchIds.append(1)
        print(savedMatchIds[0])
    }

}
