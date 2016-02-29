//
//  FavoriteTableViewCell.swift
//  FlavorFinder
//
//  Created by Jon on 2/28/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var ingredientIcons: UICollectionView!
    
    var icons = [UIImage]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        ingredientIcons.transform = CGAffineTransformMakeScale(-1, 1)
        
            let imageVegan = UIImage(named: "Vegan")!
            self.icons.append(imageVegan)
            let imageNuts = UIImage(named: "Nuts")!
            self.icons.append(imageNuts)
            let imageDairy = UIImage(named: "Dairy")!
            self.icons.append(imageDairy)
        
        self.ingredientIcons.reloadData()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "FavIngredientIconCVCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as UICollectionViewCell
        let icon = icons[indexPath.row]
        for view in cell.subviews {
            view.removeFromSuperview()
        }
        
        cell.contentView.transform = CGAffineTransformMakeScale(-1, 1)
        
        let imageView = UIImageView(image: icon)
        imageView.backgroundColor = UIColor.clearColor()
        imageView.frame = CGRect(x: 0, y: 5, width: 30, height: 30)
        cell.addSubview(imageView)
        
        return cell
    }
    
}