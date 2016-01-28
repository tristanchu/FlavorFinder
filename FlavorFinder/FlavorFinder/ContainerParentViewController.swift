//
//  ContainerParentViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 1/17/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//
//  Parents of the ContainerViewController should extend this class to have access to child container VCs.
//  Classes extending this class should set the segueEmbeddedContent string in an override prepareForSegue func,
//  prior to calling super.prepareForSegue()
//

import Foundation
import UIKit

class ContainerParentViewController : UIViewController {
    var containerVC : ContainerViewController?
    var segueEmbeddedContent : String? // should be set in extended prepareforSegue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // keep track of the embedded container view controller so you can manage subviews
        if segueEmbeddedContent != nil && segue.identifier == segueEmbeddedContent! {
            containerVC = segue.destinationViewController as? ContainerViewController
        }
    }
    
}
