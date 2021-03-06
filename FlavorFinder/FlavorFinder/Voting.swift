//
//  Voting.swift
//  FlavorFinder
//
//  Created by Jon on 10/27/15.
//  Copyright © 2015 TeamFive. All rights reserved.
//

// see https://medium.com/hacking-and-gonzo/how-reddit-ranking-algorithms-work-ef111e33d0d9#.gct33voi1

import Foundation

func _confidence(ups: Int, downs: Int) -> Double {
    let n = Double(ups) + Double(downs)
    
    if (n == 0) {
        return 0
    }
    
    let z = 1.0 // statistical confidence level: 1.0 = 85%, 1.6 = 95%
    let phat = Double(ups) / n;
    
    let comp1 = phat*(1-phat)
    let comp2 = ((comp1+z*z/(4*n))/n)
    return sqrt(phat+z*z/(2*n)-z*comp2)/(1+z*z/n)
}

func confidence(ups: Int, downs: Int) -> Double {
    if (ups + downs == 0) {
        return 0
    } else {
        return _confidence(ups, downs: downs)
    }
}
