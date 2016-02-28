//
//  UiUtils.swift
//  FlavorFinder
//
//  Created by Courtney Ligh on 11/5/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit

// ----------------------------------------------------------------------
// ALERT FUNCTIONS ------------------------------------------------------
// ----------------------------------------------------------------------

/**
alertPopup

Gives user an alert notification with the given text.

@param: title - String - the Bolded text in the notification
@param: msg - String - the non-bold text in the notificaiton
@param: actionTitle - String - the button text
@param: currController - UIViewController - the controller sending the alert.
*/
func alertPopup(title: String, msg: String, actionTitle: String,
    currController: UIViewController) -> Void {

        let alertView = UIAlertController(title: title,
            message: msg,
            preferredStyle:.Alert)
        let okAction = UIAlertAction(title: actionTitle,
            style: .Default,
            handler: nil)
        alertView.addAction(okAction)
        currController.presentViewController(alertView,
            animated: true,
            completion: nil)
}

// ----------------------------------------------------------------------
// BUTTON FUNCTIONS -----------------------------------------------------
// ----------------------------------------------------------------------


/* setUpNaviButton
- sets up a navigation button for navi style
*/
func setUpNaviButton(button: UIBarButtonItem, buttonString: String, target: UIViewController?, action: Selector) {
    button.setTitleTextAttributes(attributes, forState: .Normal)
    button.title = buttonString
    button.tintColor = NAVI_BUTTON_COLOR
    button.target = target
    button.action = action
}

/* configureFilterButton
- sets up a filter button visually, but does not specify action or target
*/
func configureFilterButton(button: UIButton, titleString: String, image: UIImage) {
    button.setTitle(titleString.capitalizedString, forState: .Normal)
    button.layer.cornerRadius = 10
    button.layer.borderWidth = 1
    button.layer.borderColor = NAVI_BUTTON_COLOR.CGColor
    button.backgroundColor = UIColor.clearColor()
    button.titleLabel?.font = UIFont(name: "Avenir Next Medium", size: 15)
    button.setImage(image, forState: .Normal)
}
