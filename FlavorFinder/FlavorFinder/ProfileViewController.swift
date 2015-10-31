//
//  ProfileViewController.swift
//  FlavorFinder
//
//  Created by Jon on 10/26/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ///self.navigationItem.hidesBackButton = true
        
        if let navi = self.navigationController as? MainNavigationController {
            navi.navigationItem.setLeftBarButtonItems([], animated: true)
            navi.navigationItem.setRightBarButtonItems([navi.menuBarBtn], animated: true)
            navi.reset_navigationBar()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        // if view revisted in app, load again
        load();
        super.viewDidAppear(animated);
    }
    
    func load() {
        /// need offline vs online options
    }
    
    func loadSavedMatches() { // a.k.a. load favorites
        //// NSUserDefaults to cache favorites for offline recall too?
    }
    
    /// viewDidLoad vs. viewWillAppear vs. loading indicator
    /// "If you pack all of your network communication into viewDidLoad or viewWillAppear, they will be executed before the user gets to see the view - possibly resulting a short freeze of your app. It may be good idea to first show the user an unpopulated view with an activity indicator of some sort. When you are done with your networking, which may take a second or two (or may even fail - who knows?), you can populate the view with your data."
    /// http://stackoverflow.com/questions/1579550/uiviewcontroller-viewdidload-vs-viewwillappear-what-is-the-proper-division-of
    /// another person advises viewDidAppear for those server calls to avoid lagginess in animations etc http://stackoverflow.com/questions/5630649/what-is-the-difference-between-viewwillappear-and-viewdidappear


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
