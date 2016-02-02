//
//  NewSearchViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 1/13/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//
//  Handles search bar interaction on the new search state of the landing page.
//  Also handles logged in logic to determine whether or not to display login/register container.
//

import Foundation
import UIKit
import Parse

class NewSearchViewController : ContainerParentViewController,
        UISearchBarDelegate, UITableViewDelegate {
    
    // MARK: Properties:
    var activeSearch : Bool = false
    var allIngredients = [PFObject]() // set on load
    var filteredResults : [PFObject] = []

    // Identifiers from storyboard: (note, constraints on there)
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appIconView: UIImageView!
    @IBOutlet weak var searchPrompt: UILabel!
    @IBOutlet weak var newSearchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
//    @IBOutlet weak var newSearchSearchBar: UISearchBar!


    // Segues:
    let segueLoginEmbedded = "segueLoginEmbedSubview"
    let segueToLogin = "goToLogin"
    let segueToRegister = "goToRegister"

    // Testing:
    var debugLoggedIn = false

    // MARK: Override Functions:

    /* viewDidLoad
        - called when app first loaded
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        // get _allIngredients - loaded by _readIngredients by appDelegate
        allIngredients = _allIngredients

        // set up delegates:
        newSearchBar.delegate = self
        searchResultTableView.delegate = self
//        searchResultTableView.dataSource = self
    }

    /* viewDidAppear
        - called when user goes; to view
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Rounded edges for search bar:
        self.newSearchBar.layer.cornerRadius = 15
        self.newSearchBar.clipsToBounds = true

        // Hide search bar results on load:
        searchResultTableView.hidden = true

        // Hide/Show login container based on if user is logged in:
        if currentUser != nil {
            containerVC?.view.hidden = true
        } else {
            containerVC?.view.hidden = false
            
            // Rounded edges for container:
            containerVC?.view.layer.cornerRadius = 20
            containerVC?.view.clipsToBounds = true
            
            // Shows login first
            goToLogin()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if self.segueEmbeddedContent == nil {
            self.setValue(segueLoginEmbedded, forKey: "segueEmbeddedContent")
        }
        super.prepareForSegue(segue, sender: sender)
    }
    
    func goToLogin() {
        containerVC?.segueIdentifierReceivedFromParent(segueToLogin)
    }
    
    func goToRegister() {
        containerVC?.segueIdentifierReceivedFromParent(segueToRegister)
    }
    
}