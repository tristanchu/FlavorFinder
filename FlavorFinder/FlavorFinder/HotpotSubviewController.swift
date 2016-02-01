//
//  HotpotSubviewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 1/31/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit
import Parse
import MGSwipeTableCell
import DZNEmptyDataSet
import DOFavoriteButton
import Darwin
import ASHorizontalScrollView

class HotpotSubviewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    // class constants
    let CELL_IDENTIFIER = "hotpotCell"
    let CELL_HEIGHT : CGFloat = 40
    let EDGE_INSET = 10
    let ITEM_WIDTH : CGFloat = 100
    let FRAME_WIDTH : CGFloat = 200 // debug: arbitrary for now
    let HOTPOT_COLOR = NAVI_COLOR
    let CELL_LABEL_FONT = UIFont(name: "Avenir Next Bold", size: 16)
    let CELL_X_POS : CGFloat = 3
    let CELL_Y_POS : CGFloat = -3
    let CELL_LABEL_COLOR = UIColor.whiteColor()
    let REMOVE_BTN_FONT = UIFont.fontAwesomeOfSize(20)
    let CELL_BKGD_COLOR = NAVI_LIGHT_COLOR
    
    // class variables
    var hotpot = [PFIngredient(name: "Cinnamon"), PFIngredient(name: "Garlic")]
    var layout = UICollectionViewFlowLayout()

    // SETUP FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        layout.itemSize = CGSize(width: ITEM_WIDTH, height: CELL_HEIGHT)
//        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        //collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.backgroundColor = HOTPOT_COLOR
        collectionView!.reloadData()
    }
    
    // COLLECTION
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotpot.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_IDENTIFIER, forIndexPath: indexPath) as! HotpotCollectionViewCell
        let ingredient = hotpot[indexPath.row]
        
        let name : NSString = ingredient[_s_name] as! NSString
        let size : CGSize = name.sizeWithAttributes([NSFontAttributeName: UIFont.fontAwesomeOfSize(25)])
        cell.nameLabel.frame = CGRectMake(CELL_X_POS, CELL_Y_POS, size.width, size.height)
        cell.nameLabel.text = ingredient[_s_name] as? String
        cell.nameLabel.font = CELL_LABEL_FONT
        cell.nameLabel.textColor = CELL_LABEL_COLOR
        cell.addSubview(cell.nameLabel)
        
        cell.removeBtn.frame = CGRectMake(cell.frame.width - 25, 0, 20, 20)
        cell.removeBtn.titleLabel?.font = REMOVE_BTN_FONT
        cell.removeBtn.setTitle(String.fontAwesomeIconWithName(.Remove), forState: .Normal)
        cell.removeBtn.tintColor = NAVI_BUTTON_COLOR
        cell.removeBtn.addTarget(self, action: Selector("removeHotpotIngredientClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        cell.removeBtn.ingredient = ingredient
        cell.addSubview(cell.removeBtn)
        
        cell.backgroundColor = CELL_BKGD_COLOR
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    func removeHotpotIngredientClicked(sender: RemoveHotpotIngredientButton) {
//        hotpot.removeAtIndex(hotpot.indexOf(sender.ingredient!)!)
//        hotpotView?.reloadData()
        
        if hotpot.isEmpty {
            //// tell your parent!
            print("DEBUG: hotpot empty / new search time!")
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let ingredient : PFObject = hotpot[indexPath.row]
        let name : NSString = ingredient[_s_name] as! NSString
        var size : CGSize = name.sizeWithAttributes([NSFontAttributeName: UIFont.fontAwesomeOfSize(20)])
        size.width += 25
        return size
    }

}