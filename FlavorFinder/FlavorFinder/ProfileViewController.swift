//
//  ProfileViewController.swift
//  FlavorFinder
//
//  Created by Jon on 10/26/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var savedMatchIds: [Int] = [Int]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ///self.navigationItem.hidesBackButton = true
        
        if let navi = self.navigationController as? MainNavigationController {
            navi.navigationItem.setLeftBarButtonItems([], animated: true)
            navi.navigationItem.setRightBarButtonItems([navi.menuBarBtn], animated: true)
            navi.reset_navigationBar()
        }
        print("!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidAppear(animated: Bool) {
        // if view revisted in app, load again
        self.load();
        super.viewDidAppear(animated)
    }
    
    func load() {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
