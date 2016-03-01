//
//  TextUtils.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 2/15/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit

/* emptyBackgroundText
 - returns a UILabel for when there is no data to display that is centered in view
 - recommended for calling VC to set view background to the returned label
 - text = text to display
*/
func emptyBackgroundText(text: String, view: UIView) -> UILabel {
    let noDataLabel: UILabel = UILabel(frame: CGRectMake(
        0, 0, view.bounds.size.width,
        view.bounds.size.height))
    noDataLabel.text = text
    noDataLabel.textColor = EMPTY_SET_TEXT_COLOR
    noDataLabel.textAlignment = NSTextAlignment.Center
    noDataLabel.font = EMPTY_SET_FONT
    return noDataLabel
}