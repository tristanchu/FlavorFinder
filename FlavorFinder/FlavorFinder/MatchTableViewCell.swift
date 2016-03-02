//
//  MatchTableViewCell.swift
//  FlavorFinder
//
//  Created by Jon on 10/8/15.
//  Copyright (c) 2015 TeamFive. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class MatchTableViewCell: MGSwipeTableCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel! // original version of cell
    @IBOutlet weak var label: UILabel! // contained version of cell
    @IBOutlet var upvoteLabel: UILabel!
    @IBOutlet var downvoteLabel: UILabel!
    @IBOutlet weak var ingredientIcons: UICollectionView!
    
    var icons = [UIImage]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        ingredientIcons.transform = CGAffineTransformMakeScale(-1, 1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "ingredientIconCVCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as UICollectionViewCell
        let icon = icons[indexPath.row]
        for view in cell.subviews {
            view.removeFromSuperview()
        }
        let imageView = UIImageView(image: icon)
        imageView.transform = CGAffineTransformMakeScale(-1, 1)
        imageView.backgroundColor = UIColor.clearColor()
//        imageView.frame = CGRect(x: 0, y: 5, width: 30, height: 30)
        cell.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(35, 35)
    }
}
