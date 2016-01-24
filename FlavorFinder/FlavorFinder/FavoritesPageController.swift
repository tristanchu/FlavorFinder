//
//  FavoritesPageController.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 1/10/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import Parse
import UIKit

class FavoritesPageController : UIViewController, UITextFieldDelegate {

    @IBOutlet weak var favLabel: UILabel!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // update view here!

        // test
        favLabel.text = currentUser?.username;
    }


}
