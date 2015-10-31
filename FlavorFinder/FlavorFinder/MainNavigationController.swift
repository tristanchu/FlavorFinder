//
//  MainNavigationController.swift
//  FlavorFinder
//
//  Created by Jon on 10/27/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit
import FontAwesome_swift


class MainNavigationController: UINavigationController {
    var history = Stack<AnyObject?>()  // Used for going backward.
    var future = Stack<AnyObject?>()   // Used for going forward.
    
    var goBackBtn: UIBarButtonItem = UIBarButtonItem()
    var goForwardBtn: UIBarButtonItem = UIBarButtonItem()
    
    var searchBarActivateBtn: UIBarButtonItem = UIBarButtonItem()
    lazy var searchBar = UISearchBar(frame: CGRectMake(0, 0, 0, 0))
    var searchTableView: UITableView = UITableView()
    var globalSearchViewController: GlobalSearchController = GlobalSearchController()
    
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
//        configure_searchBar()
        configure_searchBarActivateBtn()
        configure_menuTableView()
    }
    
    func configure_menuTableView() {
        menuTableViewController.navi = self
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
        menuTableView.hidden = true
        self.view.addSubview(menuTableView)
    }
    
    func configure_searchBar() {
        globalSearchViewController.navi = self
        searchBar.delegate = globalSearchViewController
        searchBar.hidden = true
        searchBar.setShowsCancelButton(true, animated: false)
        let cancelButton = searchBar.valueForKey("cancelButton") as! UIButton
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        cancelButton.setTitle(String.fontAwesomeIconWithName(.ChevronLeft), forState: UIControlState.Normal)
        
        let y_offset = UIApplication.sharedApplication().statusBarFrame.size.height + self.navigationBar.frame.height
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        searchTableView.frame = CGRect(x: 0, y: y_offset, width: screenSize.width, height: screenSize.height*0.5)
//        searchTableView.sizeToFit()
        searchTableView.delegate = globalSearchViewController
        searchTableView.dataSource = globalSearchViewController
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
    
    func goBackBtnClicked() {
        if self.visibleViewController is RegisterViewController {
            let transition: CATransition = CATransition()
            
            //            transition.duration = 0.25
            //            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
            transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
            
            self.view.layer.addAnimation(transition, forKey: "kCATransition")
            
            let loginViewControllerObject = mainStoryboard.instantiateViewControllerWithIdentifier(LoginViewControllerIdentifier) as? LoginViewController
            self.pushViewController(loginViewControllerObject!, animated: true)
        } else if let matchTableViewControllerObject = self.visibleViewController as? MatchTableViewController {
            if let curr = matchTableViewControllerObject.currentIngredient {
                goForwardBtn.enabled = true
                future.push(curr)

                if let pastObject = history.pop() {
                    if let pastIngredient = pastObject as? Ingredient {
                        matchTableViewControllerObject.showIngredient(pastIngredient)
                    }
                } else {
                    goBackBtn.enabled = false
                    matchTableViewControllerObject.showAllIngredients()
                }
            }
        }
    }
    
    func getVisibleViewControllerIdentifier() -> String {
        switch self.visibleViewController {
        case is MatchTableViewController:
            return MatchTableViewControllerIdentifier
        case is ProfileViewController:
            return ProfileViewControllerIdentifier
        default:
            return ""
        }
    }
    
    func goForwardBtnClicked() {
        if let matchTableViewControllerObject = self.visibleViewController as? MatchTableViewController {
            if let futureObject = future.pop() {
                if let curr = matchTableViewControllerObject.currentIngredient {
                    history.push(curr)
                }
                
                goBackBtn.enabled = true
                if (future.isEmpty()) {
                    goForwardBtn.enabled = false
                }
                
                if let futureViewIdentifier = futureObject as? String {
                    
                } else if let futureIngredient = futureObject as? Ingredient {
                    matchTableViewControllerObject.showIngredient(futureIngredient)
                }
            }
        }
    }
    
    func pushToHistory() {
        if let matchTableViewControllerObject = self.visibleViewController as? MatchTableViewController {
            future.removeAll()
            if let curr = matchTableViewControllerObject.currentIngredient {
                history.push(curr)
            }
            goBackBtn.enabled = true
            goForwardBtn.enabled = false
        }
    }
    
    func menuBtnClicked() {
        print("menuBtn clicked.")
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


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        hideSearchBar()
//        if let matchTableViewControllerObject = self.visibleViewController as? MatchTableViewController {
//            matchTableViewControllerObject.filterResults("")
//        }
//    }
//    
    func hideSearchBar() {
        var newTitle = ""
        if let matchTableViewControllerObject = self.visibleViewController as? MatchTableViewController {
            if let curr = matchTableViewControllerObject.currentIngredient {
                newTitle = curr.name
            } else {
                newTitle = TITLE_ALL_INGREDIENTS
            }
        }
        
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
