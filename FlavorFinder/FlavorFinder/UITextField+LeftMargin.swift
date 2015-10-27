//
//  UITextField+LeftMargin.swift
//  FlavorFinder
//
//  Created by Sudikoff Lab iMac on 10/27/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit
import Foundation

extension UITextField {
    func setTextLeftPadding(left:CGFloat) {
        let leftView:UIView = UIView(frame: CGRectMake(0, 0, left, 1))
        leftView.backgroundColor = UIColor.clearColor()
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewMode.Always;
    }
}