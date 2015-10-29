//
//  MenuTableViewController.swift
//  FlavorFinder
//
//  Created by Sudikoff Lab iMac on 10/27/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit

func animateMenuTableView(tableView: UITableView, dismiss: Bool) {
    tableView.reloadData()
    
    let cells = tableView.visibleCells
    let tableHeight: CGFloat = tableView.bounds.size.height
    
    let start = dismiss ? CGFloat(0) : -1*tableHeight
    //        let end = dismiss ? -1*tableHeight : CGFloat(0)
    let end = dismiss ? CGFloat(0) : CGFloat(0)
    
    var orderedCells: [UITableViewCell]
    
    if dismiss {
        orderedCells = cells.reverse()
    } else {
        orderedCells = cells
        for i in cells {
            let cell: UITableViewCell = i
            cell.transform = CGAffineTransformMakeTranslation(0, -1*tableHeight)
        }
    }
    
    var index = 0
    
    for a in orderedCells {
        let cell: UITableViewCell = a
        UIView.animateWithDuration(0.5, delay: 0.03 * Double(index), usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
            cell.transform = CGAffineTransformMakeTranslation(0, end);
            }, completion:
            { finished in
                if dismiss {
                    tableView.hidden = true
                }
            }
        )
        
        index += 1
    }
}


class MenuTableViewController: UITableViewController {

    var menuTableItems = [  String.fontAwesomeIconWithName(.User) + " Profile",
        String.fontAwesomeIconWithName(.Cutlery) + " Ingredients",
        String.fontAwesomeIconWithName(.SignOut) + " Sign Out"
    ]
    let CELLIDENTIFIER_MENU = "menuCell"

    let segueMenuToLogin = "segueMenuToLogin"
    let segueMenuToMatch = "segueMenuToMatch"
    let segueMenuToProfile = "segueMenuToProfile"
    
    var navi: MainNavigationController?
    
//    var menuTableView: UITableView = UITableView()

    override func viewDidLoad() {
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.width, 200);
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CELLIDENTIFIER_MENU)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.tableFooterView = UIView.init(frame: CGRectZero)
        self.tableView.tableFooterView!.hidden = true
        self.tableView.backgroundColor = UIColor.clearColor()
//        self.view.addSubview(self.tableView)
        self.tableView.hidden = true
    }
    
//    init(storyboard: UIStoryboard) {
//        mainStoryboard = storyboard
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func animateMenuTableView(dismiss: Bool) {
//        self.tableView.reloadData()
//        
//        let cells = self.tableView.visibleCells
//        let tableHeight: CGFloat = self.tableView.bounds.size.height
//        
//        let start = dismiss ? CGFloat(0) : -1*tableHeight
//        //        let end = dismiss ? -1*tableHeight : CGFloat(0)
//        let end = dismiss ? CGFloat(0) : CGFloat(0)
//        
//        var orderedCells: [UITableViewCell]
//        
//        if dismiss {
//            orderedCells = cells.reverse()
//        } else {
//            orderedCells = cells
//            for i in cells {
//                let cell: UITableViewCell = i
//                cell.transform = CGAffineTransformMakeTranslation(0, -1*tableHeight)
//            }
//        }
//        
//        var index = 0
//        
//        for a in orderedCells {
//            let cell: UITableViewCell = a
//            UIView.animateWithDuration(0.5, delay: 0.03 * Double(index), usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
//                cell.transform = CGAffineTransformMakeTranslation(0, end);
//                }, completion:
//                { finished in
//                    if dismiss {
//                        self.tableView.hidden = true
//                    }
//                }
//            )
//            
//            index += 1
//        }
//    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(CELLIDENTIFIER_MENU, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.font = UIFont.fontAwesomeOfSize(15)
        cell.textLabel?.text = self.menuTableItems[indexPath.row]
        cell.textLabel?.textAlignment = .Center
        
        switch indexPath.row {
        case 0:
            cell.backgroundColor = UIColor(red: 59/255.0, green: 247/255.0, blue: 194/255.0, alpha: CGFloat(1.0))
            break
        case 1:
            cell.backgroundColor = UIColor(red: 105/255.0, green: 230/255.0, blue: 255/255.0, alpha: CGFloat(1.0))
            break
        case 2:
            cell.backgroundColor = UIColor(red: 227/255.0, green: 78/255.0, blue: 59/255.0, alpha: CGFloat(1.0))
            
            break
        default:
            cell.backgroundColor = UIColor(red: 105/255.0, green: 230/255.0, blue: 255/255.0, alpha: CGFloat(1.0))
            break
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        print("You selected cell #\(indexPath.row)!")
        let mainStoryboard = UIStoryboard(name: "Main", bundle:nil)
        switch indexPath.row {
        case 0:
            let profileViewControllerObject = mainStoryboard.instantiateViewControllerWithIdentifier("ProfileViewControllerIdentifier") as? ProfileViewController
            navi?.pushViewController(profileViewControllerObject!, animated: true)
            break
        case 1:
            let matchTableViewControllerObject = mainStoryboard.instantiateViewControllerWithIdentifier("MatchTableViewControllerIdentifier") as? MatchTableViewController
//            self.navigationController?.pushViewController(matchTableViewControllerObject!, animated: true)
//            let matchTableViewControllerObject: MatchTableViewController = MatchTableViewController()
//            let navi = MainNavigationController(rootViewController: matchTableViewControllerObject!)
//            self.presentViewController(navi, animated: true, completion: nil)
            navi?.pushViewController(matchTableViewControllerObject!, animated: true)
            break
        case 2:
//            if let navi = self.navigationController as? MainNavigationController {
//                let loginViewControllerObject = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewControllerIdentifier") as? LoginViewController
//                navi.pushViewController(loginViewControllerObject!, animated: true)
////                self.navigationController?.pushViewController(loginViewControllerObject!, animated: true)
//            }
//            self.performSegueWithIdentifier(segueMenuToLogin, sender:self)
//            let loginViewControllerObject: LoginViewController = LoginViewController()
            let loginViewControllerObject = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewControllerIdentifier") as? LoginViewController
//            let navi = MainNavigationController(rootViewController: loginViewControllerObject!)
//            self.presentViewController(navi, animated: true, completion: nil)
            navi?.pushViewController(loginViewControllerObject!, animated: true)
            break
        default:
            break
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuTableItems.count
    }
}
