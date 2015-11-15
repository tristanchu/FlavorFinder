//
//  SavedMatchesViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 11/14/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit
import Parse

class SavedMatchesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    //// using for some inspiration and direction: http://www.raywenderlich.com/78550/beginning-ios-collection-views-swift-part-1
    
    @IBOutlet weak var savedMatchesView: UICollectionView!
    
    private let reuseIdentifier = "SavedMatchesCell"
    
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    private var savedMatches = [[PFObject]]()
    
    func matchForIndexPath(indexPath: NSIndexPath) -> PFObject {
        return savedMatches[indexPath.section][indexPath.row]
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedMatches[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : SavedMatchesCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SavedMatchesCell
        
        let match = matchForIndexPath(indexPath)
        if let ingredientName: String = match.objectForKey("ingredientName") as? String {
            if let matchName: String = match.objectForKey("matchName") as? String {
                cell.savedMatchLabel.text = "\(ingredientName)\n + \n\(matchName)"
            }
        } else {
            cell.savedMatchLabel.text = "???"
            print(match)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    func addMatches(matches: [PFObject]) {
        savedMatches.insert(matches, atIndex: 0)
        savedMatchesView.reloadData()
    }
    
    
    /**
     viewDidLoad  --override
     
     DEBUG because this is going to be a subview...
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar
        if let navi = self.navigationController as? MainNavigationController {
            navi.navigationItem.setLeftBarButtonItems([], animated: true)
            navi.navigationItem.setRightBarButtonItems([navi.menuBarBtn], animated: true)
            navi.reset_navigationBar()
            navi.navigationItem.title = "FAVORITES (debug version)"
        }
        
        if let userId = currentUser?.objectId {
            print("adding matches")
            addMatches(getUserFavoritesFromLocal(userId))
        }
    }
}
