//
//  MenuTableViewController.swift
//  FlavorFinder
//
//  Created by Jon on 10/27/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit


class MenuTableViewController: UITableViewController {

    let menuTableItems = [ String.fontAwesomeIconWithName(.User) + " Profile",
        String.fontAwesomeIconWithName(.Cutlery) + " Ingredients",
        String.fontAwesomeIconWithName(.SignOut) + " Sign Out"
    ]
    
    var navi: MainNavigationController?
    
    // Button Colors:
    let PROFILE_BGCOLOR = UIColor(red: 59/255.0, green: 247/255.0, blue: 194/255.0, alpha: CGFloat(1.0))
    let INGREDIENTS_BGCOLOR = UIColor(red: 105/255.0, green: 230/255.0, blue: 255/255.0, alpha: CGFloat(1.0))
    let SIGNIN_BGCOLOR = UIColor(red: 227/255.0, green: 78/255.0, blue: 59/255.0, alpha: CGFloat(1.0))

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(CELLIDENTIFIER_MENU, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.font = UIFont.fontAwesomeOfSize(15)
        cell.textLabel?.text = self.menuTableItems[indexPath.row]
        cell.textLabel?.textAlignment = .Center
        
        switch indexPath.row {
        case 0:
            cell.backgroundColor = PROFILE_BGCOLOR
            break
        case 1:
            cell.backgroundColor = INGREDIENTS_BGCOLOR
            break
        case 2:
            cell.backgroundColor = SIGNIN_BGCOLOR
            break
        default:
            cell.backgroundColor = INGREDIENTS_BGCOLOR
            break
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        print("You selected cell #\(indexPath.row)!")
        let mainStoryboard = UIStoryboard(name: "Main", bundle:nil)
        switch indexPath.row {

        // Profile Button:
        case 0:
            if navi?.visibleViewController is ProfileViewController {
                navi?.dismissMenuTableView()
            } else {
//                navi?.history.push(navi?.getVisibleViewControllerIdentifier())
                let profileViewControllerObject = mainStoryboard.instantiateViewControllerWithIdentifier(ProfileViewControllerIdentifier) as? ProfileViewController
                navi?.pushViewController(profileViewControllerObject!, animated: true)
            }
            break

        // Ingredients Button:
        case 1:
            if let matchTableViewControllerObject = navi?.visibleViewController as? MatchTableViewController {
                navi?.dismissMenuTableView()
                matchTableViewControllerObject.showAllIngredients()
            } else {
//                navi?.history.push(navi?.getVisibleViewControllerIdentifier())
                let matchTableViewControllerObject = mainStoryboard.instantiateViewControllerWithIdentifier(MatchTableViewControllerIdentifier) as? MatchTableViewController
                navi?.pushViewController(matchTableViewControllerObject!, animated: true)
            }
            break
        // Sign Out Button:
        case 2:
            // If on Login View:
            if navi?.visibleViewController is LoginViewController {
                navi?.dismissMenuTableView()
            // If not on Login View, Log out and transition to it.
            } else {
                // Log out user (remove session data)
                removeUserSession()
                // Transition to Login View:
                let transition: CATransition = CATransition()
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromLeft
                navi?.view.layer.addAnimation(transition, forKey: "kCATransition")
                
                let loginViewControllerObject = mainStoryboard.instantiateViewControllerWithIdentifier(LoginViewControllerIdentifier) as? LoginViewController
                navi?.pushViewController(loginViewControllerObject!, animated: true)
            }
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
