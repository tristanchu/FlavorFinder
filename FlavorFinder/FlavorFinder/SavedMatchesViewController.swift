//
//  SavedMatchesViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 11/14/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit
import Parse

class SavedMatchesViewController: UIViewController {
    private let reuseIdentifier = "SavedMatchesCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private var savedMatches = [[PFObject]]()
    
    func matchForIndexPath(indexPath: NSIndexPath) -> PFObject {
        return savedMatches[indexPath.section][indexPath.row]
    }

}
