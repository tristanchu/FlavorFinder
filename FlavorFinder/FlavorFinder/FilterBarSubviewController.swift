//
//  FilterBarSubviewController.swift
//  FlavorFinder
//
//  Created by Jaki Kimball on 1/31/16.
//  Copyright © 2016 TeamFive. All rights reserved.
//

import Foundation
import UIKit
import ASHorizontalScrollView

class FilterBarSubviewController : UIViewController, UISearchBarDelegate {
    
    let placeholderText = "Filter results by name..."
    
    var filterView: ASHorizontalScrollView = ASHorizontalScrollView()
    var filterSearchBar = UISearchBar()
    var filters: [String: Bool] = [F_KOSHER: false,
        F_DAIRY: false,
        F_VEG: false,
        F_NUTS: false]
    
    override func viewDidLoad() {
        
        view.backgroundColor = NAVI_COLOR
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        filterView.frame = CGRectMake(0, 0, screenSize.width, K_CELL_HEIGHT+5)
        filterView.backgroundColor = NAVI_COLOR
        filterView.leftMarginPx = 20
        filterView.miniAppearPxOfLastItem = 10
        filterView.uniformItemSize = CGSizeMake(115, 33)
        
        // this must be called after changing any size or margin property of this class to get accurate margin
        filterView.setItemsMarginOnce()
        
//        let kosherBtn = UIButton()
//        kosherBtn.setTitle(F_KOSHER.capitalizedString, forState: .Normal)
//        kosherBtn.layer.cornerRadius = 10
//        kosherBtn.layer.borderWidth = 1
//        kosherBtn.layer.borderColor = NAVI_BUTTON_COLOR.CGColor
//        kosherBtn.backgroundColor = UIColor.clearColor()
//        kosherBtn.titleLabel?.font = UIFont.fontAwesomeOfSize(15)
//        kosherBtn.tag = 1
//        kosherBtn.addTarget(self, action: "filterToggleBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
//        filterView.addItem(kosherBtn)
        
        
        let dairyBtn = UIButton()
        configureFilterButton(dairyBtn, titleString: F_DAIRY, image: UIImage(named: "NoDairy")!)
        dairyBtn.tag = 2
        dairyBtn.addTarget(self, action: "filterToggleBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        filterView.addItem(dairyBtn)
        
        let vegeBtn = UIButton()
        configureFilterButton(vegeBtn, titleString: F_VEG, image: UIImage(named: "Vegetarian")!)
        vegeBtn.tag = 3
        vegeBtn.addTarget(self, action: "filterToggleBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        filterView.addItem(vegeBtn)
        
        let nutsBtn = UIButton()
        configureFilterButton(nutsBtn, titleString: F_NUTS, image: UIImage(named: "NoNuts")!)
        nutsBtn.tag = 4
        nutsBtn.addTarget(self, action: "filterToggleBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        filterView.addItem(nutsBtn)
        
        self.view.addSubview(filterView)
        
        filterSearchBar.frame = CGRectMake(0, K_CELL_HEIGHT, screenSize.width, K_CELL_HEIGHT)
        filterSearchBar.layer.borderColor = NAVI_COLOR.CGColor
        filterSearchBar.layer.borderWidth = 1
        filterSearchBar.barTintColor = NAVI_COLOR
        filterSearchBar.delegate = self
        filterSearchBar.tag = 2
        filterSearchBar.placeholder = placeholderText
        self.view.addSubview(filterSearchBar)
    }
    
    func filterToggleBtnClicked(sender: UIButton) {
        switch sender.tag {
        case 1:
            if filters[F_KOSHER]! {
                filters[F_KOSHER] = false
                sender.layer.borderColor = NAVI_BUTTON_COLOR.CGColor
                sender.backgroundColor = UIColor.clearColor()
            } else {
                filters[F_KOSHER] = true
                sender.backgroundColor = FILTER_BUTTON_COLOR
            }
            break
        case 2:
            if filters[F_DAIRY]! {
                filters[F_DAIRY] = false
                sender.layer.borderColor = NAVI_BUTTON_COLOR.CGColor
                sender.backgroundColor = UIColor.clearColor()
            } else {
                filters[F_DAIRY] = true
                sender.backgroundColor = FILTER_BUTTON_COLOR
            }
            break
        case 3:
            if filters[F_VEG]! {
                filters[F_VEG] = false
                sender.layer.borderColor = NAVI_BUTTON_COLOR.CGColor
                sender.backgroundColor = UIColor.clearColor()
            } else {
                filters[F_VEG] = true
                sender.backgroundColor = FILTER_BUTTON_COLOR
            }
            break
        case 4:
            if filters[F_NUTS]! {
                filters[F_NUTS] = false
                sender.layer.borderColor = NAVI_BUTTON_COLOR.CGColor
                sender.backgroundColor = UIColor.clearColor()
            } else {
                filters[F_NUTS] = true
                sender.backgroundColor = FILTER_BUTTON_COLOR
            }
            break
        default:
            break
        }
        
        // Let parent know that filter button was toggled
        if let parent = parentViewController as! SearchResultsViewController? {
            if let searchText = filterSearchBar.text {
                parent.filterButtonWasToggled(filters, searchText: searchText)
            } else {
                parent.filterButtonWasToggled(filters, searchText: "")
            }
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // Let parent know that filter search text was changed.
        if let parent = parentViewController as! SearchResultsViewController? {
            parent.filterSearchTextDidChange(searchText)
        }
    }
    
    func newSearchTermWasAdded() {
        filterSearchBar.text = ""
    }
    
}