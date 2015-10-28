//
//  Stack.swift
//  FlavorFinder
//
//  Created by Sudikoff Lab iMac on 10/26/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

import Foundation

var history = Stack<AnyObject?>()  // Used for going backward.
var future = Stack<AnyObject?>()   // Used for going forward.

struct Stack<Element> {
    var items = [Element]()
    mutating func push(item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element? {
        if items.isEmpty {
            return nil
        } else {
            return items.removeLast()
        }
    }
    mutating func removeAll() {
        items.removeAll()
    }
    mutating func isEmpty() -> Bool {
        return items.isEmpty
    }
}