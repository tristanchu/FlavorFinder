//
//  SearchResultsViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 1/31/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//
//  Controls LandingPage when search is in progress.
//  Manages subviews responsible for different aspects of search results view
//  by maintaining knowledge of the current search.
//

import Foundation
import UIKit

class SearchResultsViewController : UIViewController {
    
    // segues corresponding to embedded subviews
    let segueEmbedSearchResults = "goToSearchResults"
    let segueEmbedFilterBar = "goToFilterBar"
    let segueEmbedHotpot = "goToHotpot"
    
    // variables to hold the subview controllers (SVCs)
    var searchResultsSVC : UIViewController?
    var filterBarSVC : UIViewController?
    var hotpotSVC : HotpotSubviewController?
    
    // containers of subviews
    @IBOutlet weak var searchResultsContainer: UIView!
    @IBOutlet weak var filterBarContainer: UIView!
    @IBOutlet weak var hotpotContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // insert initial search logic here...
        layoutSubviews()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // keep track of the embedded subview controllers
        let vc = segue.destinationViewController
        switch segue.identifier! {
        case segueEmbedSearchResults:
            searchResultsSVC = vc
            break
        case segueEmbedFilterBar:
            filterBarSVC = vc
            break
        case segueEmbedHotpot:
            hotpotSVC = vc as? HotpotSubviewController
            break
        default:
            break
        }
    }
    
    func layoutSubviews() {
        /// not the way to do this exactly...broke interactivity by bypassing controllers
//        
//        // percent of view that subviews should take up, should add up to 1
//        let scaleTop : CGFloat = 0.2
//        let scaleMid : CGFloat = 0.2
//        let scaleBottom : CGFloat = 0.6
//        
//        // the page's content's view bounds
//        let bounds = CGRect(
//            x: self.view.bounds.origin.x,
//            y: self.view.bounds.origin.y,
//            width: self.view.bounds.size.width,
//            height: self.view.bounds.size.height
//        )
//        
//        
//        // set frames of corresponding components top-to-bottom
//        filterBarSVC?.view.frame = CGRect(
//            x: bounds.origin.x,
//            y: bounds.origin.y,
//            width: (filterBarSVC?.view.frame.size.width)!,
//            height: bounds.size.height * scaleTop
//        )
//        hotpotSVC?.view.frame = CGRect(
//            x: bounds.origin.x,
//            y: (filterBarSVC?.view.frame.maxY)!,
//            width: (hotpotSVC?.view.frame.size.width)!,
//            height: bounds.size.height * scaleMid
//        )
//        searchResultsSVC?.view.frame = CGRect(
//            x: bounds.origin.x,
//            y: (hotpotSVC?.view.frame.maxY)!,
//            width: (searchResultsSVC?.view.frame.size.width)!,
//            height: bounds.size.height * scaleBottom
//        )
    }
    
}