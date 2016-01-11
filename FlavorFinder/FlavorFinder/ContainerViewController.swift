//
//  ContainerViewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 1/11/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//  inspired by the tutorial here: https://kodesnippets.wordpress.com/2015/08/11/container-view-in-ios/
//

import UIKit

class ContainerViewController: UIViewController {
    
    var vc : UIViewController!
    var segueIdentifier : String!
    var lastViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// could call a default view with segueIdentifierReceivedFromParent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segueIdentifierReceivedFromParent(segueIdentifier: String){
        self.segueIdentifier = segueIdentifier
        print("seguing...?")
        //self.performSegueWithIdentifier(self.segueIdentifier, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifier {
//            // Avoids creation of a stack of view controllers
//            if lastViewController != nil{
//                lastViewController.view.removeFromSuperview()
//            }
//            // Adds View Controller to Container "first" or "second"
            vc = segue.destinationViewController
            self.addChildViewController(vc)
            vc.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(vc.view)
            vc.didMoveToParentViewController(self)
            lastViewController = vc
        }
    }
}