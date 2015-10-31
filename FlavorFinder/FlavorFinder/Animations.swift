//
//  Animations.swift
//  FlavorFinder
//
//  Created by Jon on 10/31/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import UIKit

func animateDropdownTableView(tableView: UITableView, dismiss: Bool) {
    tableView.reloadData()
    
    let cells = tableView.visibleCells
    let tableHeight: CGFloat = tableView.bounds.size.height
    
    let start = dismiss ? CGFloat(0) : -1*tableHeight
    //        let end = dismiss ? -1*tableHeight : CGFloat(0)
    let end = dismiss ? CGFloat(0) : CGFloat(0)
    
    var orderedCells: [UITableViewCell]
    
    if dismiss {
        orderedCells = cells.reverse()
    } else {
        orderedCells = cells
        for i in cells {
            let cell: UITableViewCell = i
            cell.transform = CGAffineTransformMakeTranslation(0, -1*tableHeight)
        }
    }
    
    var index = 0
    
    for a in orderedCells {
        let cell: UITableViewCell = a
        UIView.animateWithDuration(0.5, delay: 0.03 * Double(index), usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
            cell.transform = CGAffineTransformMakeTranslation(0, end);
            }, completion:
            { finished in
                if dismiss {
                    tableView.hidden = true
                }
            }
        )
        
        index += 1
    }
}

// Function to animate all table cells on load.
func animateTableViewCellsToLeft(tableView: UITableView) {
    tableView.reloadData()
    
    let cells = tableView.visibleCells
    let tableWidth: CGFloat = tableView.bounds.size.width
    
    for i in cells {
        let cell: UITableViewCell = i
        cell.transform = CGAffineTransformMakeTranslation(tableWidth, 0)
    }
    
    var index = 0
    
    for a in cells {
        let cell: UITableViewCell = a
        UIView.animateWithDuration(0.75, delay: 0.03 * Double(index), usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
            cell.transform = CGAffineTransformMakeTranslation(0, 0);
            }, completion: nil)
        
        index += 1
    }
}