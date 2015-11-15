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

    // MARK: Attributes -----------------------------------------------
    let TITLE_PROFILE_PAGE = "Profile"

    let segueToUserSettings = "segueProfileToUserSettings"
    let segueToSavedMatchesDEBUG = "segueProfileToSM"

    // MARK: Properties -----------------------------------------------
    @IBOutlet weak var ProfileWelcomeLabel: UILabel!
    @IBOutlet weak var profilePictureView: UIImageView!

    @IBOutlet weak var profileFavoritesLabel: UILabel! /// DEBUG
    
    @IBOutlet weak var favsCollectionView: UICollectionView!

    
    // MARK: Actions --------------------------------------------------
    @IBAction func goToSettings(sender: UIButton) {
        self.performSegueWithIdentifier(segueToUserSettings, sender: self)
    }
    
    @IBAction func goToSavedMatchesDEBUG(sender: UIButton) {
        self.performSegueWithIdentifier(segueToSavedMatchesDEBUG, sender: self)
    }

    // OVERRIDE FUNCTIONS ---------------------------------------------
    private lazy var favorites: [PFObject] = [PFObject]()

    /**
    viewDidLoad  --override
    
    Sets visuals for navigation, loads initial visuals
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.view.autoresizesSubviews = true
        
        // Display "Profile" in navigation bar
        if let navi = self.navigationController as? MainNavigationController {
            navi.navigationItem.setLeftBarButtonItems([], animated: true)
            navi.navigationItem.setRightBarButtonItems([navi.menuBarBtn], animated: true)
            navi.reset_navigationBar()
            navi.navigationItem.title = TITLE_PROFILE_PAGE
        }

        displayUserWelcomeLabel()
        displayUserPhoto(profilePictureView)

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
        } else {
            print("user is not logged in!")
        }
        super.viewDidAppear(animated)
    }
    
    // DISPLAY CONTENT FUNCTIONS ------------------------------------------

    /**
    displayUserWelcomeLabel

    Shows welcome label with username
    */
    func displayUserWelcomeLabel() {
        let username = currentUser?.username
        ProfileWelcomeLabel.text = "Hello \(username!)!"
    }
    
    /**
    displayUserFavorites
    
    Shows user favorites in view
    */
    func displayUserFavorites() {
        /// for now, just surfacing to user at a minimal level
        /// in separate view, with own controller...
        /// subviews were getting messy while
        /// still developing, will merge into one controller
    }
    

    /**
    displayUserPhoto

    Fetches and displays the UserPhoto
    */
    func displayUserPhoto(profileView: UIImageView!) {

        let userImage = currentUser!["profilePicture"] as! PFFile
        userImage.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    profileView.image = image
                }
            }
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

    Load any user data beyond what is stored in curerntUser global -- photo, etc.
    // TODO: do something with this function
     
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
    
    Loads saved matches for display in table
    @param: offline - Bool -- if user is offline
    */
    func loadSavedMatches(offline: Bool) {
        print("loading favorites for user \((currentUser?.username)!)...")
        if offline {
            /// what do we do if offline?
        } else {
            if let userId = currentUser?.objectId {
                favorites = getUserFavoritesFromLocal(userId)
            }
        }
    }

    // FLUSH CONTENT FUNCTIONS ---------------------------------------------

    /**
    flushData

    Clears out any local/cached data.
    */
    func flushData() {
        /// empty caches
        favorites = []
    }
    
    // PROFILE PAGE FUNCTIONS -------------------------------


}
