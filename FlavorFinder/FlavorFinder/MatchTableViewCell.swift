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
    @IBOutlet var ingredientIcons: UICollectionView!
    
    var icons = [UIImage]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
//        ingredientIcons.collectionViewLayout = flowLayout
        
        let imageNuts = UIImage(named: "Nuts")!
        let imageDairy = UIImage(named: "Dairy")!
        let imageVegan = UIImage(named: "Vegan")!
        icons.appendContentsOf([imageNuts, imageDairy, imageVegan])
        

        
//        var frame = self.upvoteLabel.frame
//        frame.origin.x = screenWidth - 20
//        frame.origin.y = 5
//        self.upvoteLabel.frame = frame
//        
//        frame = self.downvoteLabel.frame
//        frame.origin.x = screenWidth - 20
//        frame.origin.y = 25
//        self.downvoteLabel.frame = frame
//        
//        self.addSubview(self.upvoteLabel)
//        self.addSubview(self.downvoteLabel)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "ingredientIconCVCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! UICollectionViewCell
        let icon = icons[indexPath.section]
        
        let imageView = UIImageView(image: icon)
        imageView.frame = CGRect(x: 0, y: 50, width: 30, height: 30)
        cell.addSubview(imageView)
        
        return cell
    }
}
