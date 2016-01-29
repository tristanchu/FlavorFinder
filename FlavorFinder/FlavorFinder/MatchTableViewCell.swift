//
//  MatchTableViewCell.swift
//  FlavorFinder
//
//  Created by Jon on 10/8/15.
//  Copyright (c) 2015 TeamFive. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class MatchTableViewCell: MGSwipeTableCell {
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel! // original version of cell
    @IBOutlet weak var label: UILabel! // contained version of cell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
