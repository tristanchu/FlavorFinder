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

class HotpotSubviewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // class constants
    let CELL_IDENTIFIER = "hotpotCell"
    let CELL_HEIGHT : CGFloat = 40
    let EDGE_INSET = 10
    let ITEM_WIDTH : CGFloat = 100
    let FRAME_WIDTH : CGFloat = 200 // debug: arbitrary for now
    let HOTPOT_COLOR = NAVI_COLOR
    
    // class variables
    var hotpot = [PFObject]()
    var hotpotView : UICollectionView?
    var layout = UICollectionViewFlowLayout()

    // SETUP FUNCTIONS
    
    func setupView() {
        layout.itemSize = CGSize(width: ITEM_WIDTH, height: CELL_HEIGHT)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        let frame = CGRectMake(0, 0, FRAME_WIDTH, CELL_HEIGHT)
        hotpotView = UICollectionView(frame: frame, collectionViewLayout: layout)
        hotpotView!.delegate = self
        hotpotView!.dataSource = self
        hotpotView!.registerClass(HotpotCollectionViewCell.self, forCellWithReuseIdentifier: CELL_IDENTIFIER)
        hotpotView!.backgroundColor = HOTPOT_COLOR
        hotpotView!.hidden = true
        hotpotView!.reloadData()
    }

    
    // COLLECTION
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotpot.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_IDENTIFIER, forIndexPath: indexPath) as! HotpotCollectionViewCell
        let ingredient = hotpot[indexPath.row]
        
        let name : NSString = ingredient[_s_name] as! NSString
        let size : CGSize = name.sizeWithAttributes([NSFontAttributeName: UIFont.fontAwesomeOfSize(25)])
        //        cell.nameLabel = UILabel()
        cell.nameLabel.frame = CGRectMake(3, -3, size.width, size.height)
        cell.nameLabel.text = ingredient[_s_name] as? String
        cell.nameLabel.font = UIFont.fontAwesomeOfSize(25)
        cell.nameLabel.font = UIFont(name: "Avenir Next Bold", size: 16)
        cell.nameLabel.textColor = UIColor.whiteColor()
        //        cell.nameLabel.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 25, right: 0)
        cell.addSubview(cell.nameLabel)
        
        cell.removeBtn.frame = CGRectMake(cell.frame.width - 25, 0, 20, 20)
        cell.removeBtn.titleLabel?.font = UIFont.fontAwesomeOfSize(20)
        cell.removeBtn.setTitle(String.fontAwesomeIconWithName(.Remove), forState: .Normal)
        cell.removeBtn.tintColor = NAVI_BUTTON_COLOR
        cell.removeBtn.addTarget(self, action: Selector("removeHotpotIngredientClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        cell.removeBtn.ingredient = ingredient
        cell.addSubview(cell.removeBtn)
        //        cell.bringSubviewToFront(cell.removeBtn)
        
        cell.backgroundColor = NAVI_LIGHT_COLOR
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    func removeHotpotIngredientClicked(sender: RemoveHotpotIngredientButton) {
        hotpot.removeAtIndex(hotpot.indexOf(sender.ingredient!)!)
        hotpotView?.reloadData()
        
        if hotpot.isEmpty {
            hotpotView?.hidden = true
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