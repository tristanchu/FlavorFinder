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
import Parse

class FlavorFinderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
// Login/Register Validation Unit Tests
    
    // Test isInvalidUsername from LoginUtils - for registration
    func testIsInvalidUsername() {
        // Test that good input not seen as invalid:
        let goodInput = "testUser"
        XCTAssertFalse(isInvalidUsername(goodInput), "good username input marked invalid.")
        
        // Test that empty input is invalid:
        let emptyInput = ""
        XCTAssert(isInvalidUsername(emptyInput), "empty username input not seen as invalid.")
        
        // Test that long input handled:
        let longInput = "1234567890123456789012345678901234567890123456789012345678901234567890"
        XCTAssert(isInvalidUsername(longInput), "long username input not seen as invalid.")
    }
    
    // Test isInvalidPassword from LoginUtils - for registration
    func testIsInvalidPassword() {
        // Test that good input not seen as invalid:
        let goodInput = "testPassword"
        XCTAssertFalse(isInvalidPassword(goodInput), "good pw input marked as invalid")
        
        // Test that empty input is invalid:
        let emptyInput = "";
        XCTAssert(isInvalidPassword(emptyInput), "empty pw input not marked invalid")
        
        // Test that <min input is invalid:
        let belowMinInput = "123";
        XCTAssert(isInvalidPassword(belowMinInput), "short pw input not marked invalid")
        
        // Test that spaces are invalid:
        let spacedInput = "test spaces"
        XCTAssert(isInvalidPassword(spacedInput), "pw input with spaces not marked invalid")
        
        // Test that >max input is invalid:
        let longInput = "1234567890123456789012345678901234567890123456789012345678901234567890"
        XCTAssert(isInvalidPassword(longInput), "long pw input not marked invalid")
    }

// Lists Feature Unit Test
    func testListsFeature() {
        
        let user = PFUser()
        let name = "New List"
        let newList = IngredientList(user: user, name: name)

        // Test that new IngredientList is associated with a PFUser user
        XCTAssertEqual(newList!.getUser(), user, "user not associated with new list")
        
        // Test that new IngredientList is associated with a String name
        XCTAssertEqual(newList!.getName(), name, "name not associated with new list")
        
        // Test that IngredientList can be renamed with good input
        let goodName = "Good Name"
        newList!.rename(goodName)
        XCTAssertEqual(newList!.getName(), goodName, "failed to rename list")
        
        // Test that IngredientList will not be renamed with empty string // FAILS for now
        let noName = ""
        newList!.rename(noName)
        XCTAssertGreaterThan(newList!.getName().characters.count, 1, "renamed list to empty string")
        
        // Future tests: name max/min length for naming/renaming (since we'll want to display it), content of list
        
    }
    
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
