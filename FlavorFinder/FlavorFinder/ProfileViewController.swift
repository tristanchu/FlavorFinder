//
//  ProfileViewController.swift
//  FlavorFinder
//
//  Created by Jon on 10/26/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    // MARK: Attributes ----------------------------------------
    let TITLE_PROFILE_PAGE = "Profile"

    // MARK: Properties ----------------------------------------------
    @IBOutlet weak var ProfileWelcomeLabel: UILabel!

    // OVERRIDE FUNCTIONS ---------------------------------------------
    private lazy var savedMatchIds: [PFMatch] = [PFMatch]()
    
    /**
    viewDidLoad  --override
    
    Sets visuals for navigation.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        if let navi = self.navigationController as? MainNavigationController {
            navi.navigationItem.setLeftBarButtonItems([], animated: true)
            navi.navigationItem.setRightBarButtonItems([navi.menuBarBtn], animated: true)
            navi.reset_navigationBar()
            navi.navigationItem.title = TITLE_PROFILE_PAGE
        }

        // Update Welcome Label:
        // TODO: get username from variable set by loadContent
        let user = getUsernameFromKeychain()
        ProfileWelcomeLabel.text = "Hello " + user + "!"

    }

    /**
    didReceiveMemoryWarning --override
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.flushData()
    }

    /**
    viewDidAppear
    
    Checks that user is logged in before loading content. If no user, redirects
    to the login page.
    */
    override func viewDidAppear(animated: Bool) {
        if isUserLoggedIn() {
            // if view revisted in app, load again
            self.loadContent()
            super.viewDidAppear(animated)

        // User not logged in:
        } else {
            // DEBUG:
            print("user is not logged in! oops")
            super.viewDidAppear(animated)

            //// TODO: segue to login screen
        }
    }
    
    // LOAD CONTENT FUNCTIONS ---------------------------------------------
    
    /**
    loadContent

    Loads user data and saved matches (favorites)
    */
    func loadContent() {
        //// https://developer.apple.com/icloud/documentation/data-storage/index.html
        /// "Data that can be downloaded again or regenerated should be stored in the <Application_Home>/Library/Caches directory. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications." --> database cache!
        /// "Data that is used only temporarily should be stored in the <Application_Home>/tmp directory. Although these files are not backed up to iCloud, remember to delete those files when you are done with them so that they do not continue to consume space on the user’s device." --> really short-term cache
        /// "Use the "do not back up" attribute for specifying files that should remain on device, even in low storage situations. Use this attribute with data that can be recreated but needs to persist even in low storage situations for proper functioning of your app or because customers expect it to be available during offline use...Because these files do use on-device storage space, your app is responsible for monitoring and purging these files periodically." --> offline access to favorites?
        
        
        /// need offline vs online options
        let offline = false /// DEBUG
        loadUserData(offline)
        loadSavedMatches(offline)
    }
    
    /**
    loadUserData

    TODO: Load user data from Parse using username stored in Keychain

    @param: offline - Bool -- if user is offline
    */
    func loadUserData(offline: Bool) {
        if offline {
            /// load cached data
        } else {
            /// load user data via query
        }
    }
    
    /**
    loadSavedMatches

    TODO: Get matches (favorites) for user from Parse.
    
    @param: offline - Bool -- if user is offline
    */
    func loadSavedMatches(offline: Bool) { // a.k.a. load favorites
        /// DEBUG:
        print("loading saved matches...")
//        if let debugMatch = Match(matchId: 1, ingredientIds: [1, 5], names: ["bacon", "leeks"]) {
//            savedMatchIds.append(debugMatch)
//            print(savedMatchIds[0].description)
//        }
        return /// because we just want debug dummy data for now
        /// skeleton
        
        // NOT BEING RUN BECAUSE OF RETURN ^
        if offline {
            /// get from cached
        } else {
            let userId = 1 /// DEBUG dummy data
            let query = PFQuery(className: "Favorite")
            query.whereKey("userId", equalTo: userId)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil { // success
                    if let matches = objects {
                        for match in matches {
                            ////// do something
                            print("Got a match!") /// DEBUG
                        }
                    }
                } else {
                    print("Error loading saved matches: \(error!) \(error!.userInfo)")
                }
            }
        }
    }

    // FLUSH CONTENT FUNCTIONS ---------------------------------------------

    /**
    flushData

    Clears all stored matches for user.
    */
    func flushData() {
        savedMatchIds.removeAll()
        /// empty caches
    }
    
    // PROFILE PAGE FUNCTIONS -------------------------------


}
