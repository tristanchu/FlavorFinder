//
//  HotpotCollectionViewCell.swift
//  FlavorFinder
//
//  Created by Jon on 1/13/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit

class HotpotCollectionViewCell: UICollectionViewCell {
    
    var nameLabel: UILabel = UILabel()
    
    var removeBtn: RemoveHotpotIngredientButton = RemoveHotpotIngredientButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}