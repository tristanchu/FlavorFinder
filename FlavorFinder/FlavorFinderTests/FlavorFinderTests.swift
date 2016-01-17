//
//  FlavorFinderTests.swift
//  FlavorFinderTests
//
//  Created by Sudikoff Lab iMac on 10/4/15.
//  Copyright (c) 2015 TeamFive. All rights reserved.
//

import UIKit
import XCTest

@testable import FlavorFinder


class FlavorFinderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Test isInvalidUsername from LoginUtils - for registration
    func testIsInvalidUsername() {
        // Test that good input not seen as invalid:
        let goodInput = "testUser";
        XCTAssertFalse(isInvalidUsername(goodInput), "good input marked invalid.");
        
        // Test that empty input is invalid:
        let emptyInput = "";
        XCTAssert(isInvalidUsername(emptyInput), "empty input not seen as invalid.");
        
        // Test that long input handled:
        let longInput = "1234567890123456789012345678901234567890123456789012345678901234567890";
        XCTAssert(isInvalidUsername(longInput), "long input not seen as invalid.");
    }
    
    // Test isInvalidPassword from LoginUtils - for registration
    func testIsInvalidPassword() {
        // Test that good input not seen as invalid:
        let goodInput = "testPassword";
        XCTAssertFalse(isInvalidPassword(goodInput), "good input marked as invalid");
        
        // Test that empty input is invalid:
        let emptyInput = "";
        XCTAssert(isInvalidPassword(emptyInput), "empty input not marked invalid");
        
        // Test that <min input is invalid:
        let belowMinInput = "123";
        XCTAssert(isInvalidPassword(belowMinInput), "minimum input is at 6 char");
        
        // Test that >max input is invalid:
        let longInput = "1234567890123456789012345678901234567890123456789012345678901234567890";
        XCTAssert(isInvalidPassword(longInput), "long input not seen as invalid");
    }

    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
