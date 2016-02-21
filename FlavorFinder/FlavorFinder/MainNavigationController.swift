//
//  MainNavigationController.swift
//  FlavorFinder
//
//  Created by Jon on 10/27/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

// At some point, we should revisit this code because much of it is deprecated

import UIKit
import Parse
import FontAwesome_swift
import FilterBar

class MainNavigationController: UINavigationController {
    var history = Stack<AnyObject?>()  // Used for going backward.
    var future = Stack<AnyObject?>()   // Used for going forward.
    
    var goBackBtn: UIBarButtonItem = UIBarButtonItem()
    var goForwardBtn: UIBarButtonItem = UIBarButtonItem()
    
    var searchBarActivateBtn: UIBarButtonItem = UIBarButtonItem()
    lazy var searchBar = UISearchBar(frame: CGRectMake(0, 0, 0, 0))
    var searchTableView: UITableView = UITableView()
    
    var menuBarBtn: UIBarButtonItem = UIBarButtonItem()
    var menuTableView: UITableView = UITableView()
    var menuTableViewController: MenuTableViewController = MenuTableViewController()
    
    var dropdownIsDown = false

    let mainStoryboard = UIStoryboard(name: "Main", bundle:nil)

    // SETUP FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // ---------------
    override func viewDidLoad() {
        super.viewDidLoad()
        configure_goBackBtn()
        configure_goForwardBtn()
        configure_menuBarBtn()
        configure_searchBarActivateBtn()
        configure_menuTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configure_goBackBtn() {
        goBackBtn.setTitleTextAttributes(attributes, forState: .Normal)
        goBackBtn.title = String.fontAwesomeIconWithName(.ChevronLeft)
        goBackBtn.tintColor = NAVI_BUTTON_COLOR
        goBackBtn.target = self
        goBackBtn.action = "goBackBtnClicked"
    }
    
    func configure_goForwardBtn() {
        goForwardBtn.setTitleTextAttributes(attributes, forState: .Normal)
        goForwardBtn.title = String.fontAwesomeIconWithName(.ChevronRight)
        goForwardBtn.tintColor = NAVI_BUTTON_COLOR
        goForwardBtn.target = self
        goForwardBtn.action = "goForwardBtnClicked"
    }
    
    func configure_searchBarActivateBtn() {
        searchBarActivateBtn.setTitleTextAttributes(attributes, forState: .Normal)
        searchBarActivateBtn.title = String.fontAwesomeIconWithName(.Search)
        searchBarActivateBtn.tintColor = NAVI_BUTTON_COLOR
        searchBarActivateBtn.target = self
        searchBarActivateBtn.action = "searchBarActivateBtnClicked"
    }
    
    func configure_menuBarBtn() {
        menuBarBtn.setTitleTextAttributes(attributes, forState: .Normal)
        menuBarBtn.title = String.fontAwesomeIconWithName(.Bars)
        menuBarBtn.tintColor = NAVI_BUTTON_COLOR
        menuBarBtn.target = self
        menuBarBtn.action = "menuBtnClicked"
    }
    
    func configure_menuTableView() {
        menuTableView = menuTableViewController.tableView
        let y_offset = UIApplication.sharedApplication().statusBarFrame.size.height + self.navigationBar.frame.height
        menuTableView.frame = CGRectMake(0, y_offset, self.view.frame.width, 200);
        menuTableView.delegate = menuTableViewController
        menuTableView.dataSource = menuTableViewController
        menuTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CELLIDENTIFIER_MENU)
        menuTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        menuTableView.tableFooterView = UIView.init(frame: CGRectZero)
        menuTableView.tableFooterView!.hidden = true
        menuTableView.backgroundColor = UIColor.clearColor()
        menuTableView.layer.zPosition = 1
        menuTableView.hidden = true
        self.view.addSubview(menuTableView)
    }
    
    func configure_searchBar() {
        searchBar.hidden = true
        searchBar.setShowsCancelButton(true, animated: false)
        let cancelButton = searchBar.valueForKey("cancelButton") as! UIButton
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        cancelButton.setTitle(String.fontAwesomeIconWithName(.ChevronLeft), forState: UIControlState.Normal)
        
        let y_offset = UIApplication.sharedApplication().statusBarFrame.size.height + self.navigationBar.frame.height
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        searchTableView.frame = CGRect(x: 0, y: y_offset, width: screenSize.width, height: screenSize.height*0.5)
        searchTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CELLIDENTIFIER_MATCH)
        searchTableView.tableFooterView = UIView.init(frame: CGRectZero)
        searchTableView.tableFooterView!.hidden = true
        searchTableView.backgroundColor = UIColor.clearColor()
        searchTableView.reloadData()
        searchTableView.hidden = true
        self.view.addSubview(searchTableView)
    }
    
    func reset_navigationBar() {
        self.navigationItem.title = ""
        self.dismissMenuTableView()
    }
    
    // HISTORY/FUTURE FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // ------------------------
    func goBackBtnClicked() {
        if self.visibleViewController is RegisterViewController {
            let transition: CATransition = CATransition()
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            self.view.layer.addAnimation(transition, forKey: "kCATransition")
            
            let loginViewControllerObject = mainStoryboard.instantiateViewControllerWithIdentifier(LoginViewControllerIdentifier) as? LoginViewController
            self.pushViewController(loginViewControllerObject!, animated: true)
        }
    }
    
    // MENU FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // --------------
    func menuBtnClicked() {
        if (menuTableView.hidden) {
            showMenuTableView()
        } else {
            dismissMenuTableView()
        }
    }
    
    func showMenuTableView() {
        menuTableView.hidden = false
        menuBarBtn.title = String.fontAwesomeIconWithName(.Times)
        animateDropdownTableView(menuTableView, dismiss: false)
        dropdownIsDown = true
    }
    
    func dismissMenuTableView() {
        animateDropdownTableView(menuTableView, dismiss: true)
        menuBarBtn.title = String.fontAwesomeIconWithName(.Bars)
        dropdownIsDown = false
    }

    
    // SEARCH FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // ----------------
    func searchBarActivateBtnClicked() {
        showSearchBar()
    }
    
    func showSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.alpha = 0
        searchBar.hidden = false
        self.navigationItem.setLeftBarButtonItems([goBackBtn], animated: true)
        
        searchTableView.alpha = 0
        searchTableView.hidden = false
        
        UIView.animateWithDuration(0.5, animations: {
            self.searchBar.alpha = 1
            self.searchTableView.alpha = 1
            }, completion: { finished in
                self.searchBar.becomeFirstResponder()
        })
    }
    
    func hideSearchBar() {
        let newTitle = ""
        
        self.searchBar.alpha = 1
        searchTableView.alpha = 1
        UIView.animateWithDuration(0.3, animations: {
            self.searchBar.alpha = 0
            self.title = newTitle
            
            self.navigationItem.setLeftBarButtonItems([self.goBackBtn, self.searchBarActivateBtn], animated: true)
            
            self.searchTableView.alpha = 0
        }, completion: { finished in
            self.navigationItem.titleView = nil
        })
    }
    
}
