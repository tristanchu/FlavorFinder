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
    
    var goBackBtn: UIBarButtonItem = UIBarButtonItem()
    var goForwardBtn: UIBarButtonItem = UIBarButtonItem()
    
    var searchBarActivateBtn: UIBarButtonItem = UIBarButtonItem()
    
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
        configure_menuTableView()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if let navi = self.tabBarController {
            print("got navi")
            navi.navigationItem.setLeftBarButtonItems([], animated: true)
            navi.navigationItem.setRightBarButtonItems([], animated: true)
            print(navi.viewControllers)
            
//            if let _ = self.navTitle {
//                self.tabBarController?.navigationItem.title = "\(self.navTitle!)"
//            }
        }
        print("gone!")
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
    
    func reset_navigationBar() {
        self.navigationItem.title = ""
        self.dismissMenuTableView()
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
    
}
