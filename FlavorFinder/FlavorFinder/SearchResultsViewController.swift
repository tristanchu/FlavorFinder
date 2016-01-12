//
//  SearchResultsViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 1/11/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit
import Parse

class SearchResultsViewController : UIViewController {
    
    @IBOutlet weak var searchTermsContainer: UIView!
    
    @IBOutlet weak var searchMatchesContainer: UIView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        _debugShowColors()
    }
 
    
    func _debugShowColors() {
        searchTermsContainer.backgroundColor = MATCH_GREATEST_COLOR
        searchMatchesContainer.backgroundColor = MATCH_MEDIUM_COLOR
    }
    
}