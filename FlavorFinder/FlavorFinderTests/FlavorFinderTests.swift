//
//  FlavorFinderTests.swift
//  FlavorFinderTests
//
//  Created by Sudikoff Lab iMac on 10/4/15.
//  Copyright (c) 2015 TeamFive. All rights reserved.
//

import UIKit
import XCTest
import Parse

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
        let newList = FlavorFinder.PFList(user: user, title: name)

        // Test that new IngredientList was created
        XCTAssertNotNil(newList, "list creation failed")

        // Test that new list is associated with a PFUser user
        XCTAssertEqual(newList.getUser(), user, "user not associated with new list")
        
        // Test that new list is associated with a String name
        XCTAssertEqual(newList.getName(), name, "name not associated with new list")

        // Test that new list is empty
        XCTAssertTrue(newList.getList().isEmpty, "new list was not empty")
        
        // Test that ingredient can be added to list
        let ingredient = FlavorFinder.PFIngredient()
        newList.addIngredient(ingredient)
        XCTAssertFalse(newList.getList().isEmpty, "ingredient did not get added to list")

    }
    
// Favorites Feature Unit Test
    func testFavoritesFeature() {
        
        let user = PFUser()
        let ingredient = FlavorFinder.PFIngredient()
        let fav = FlavorFinder.PFFavorite(user: user, ingredient: ingredient)
        
        // Test that favorite ingredients can be created
        XCTAssertNotNil(fav, "favorite not created")
        
        // Test that new favorite is associated with a PFUser user
        XCTAssertEqual(fav.getUser(), user, "user not associated with new favorite")
        
        // Test that new favorite is associated with a PFIngredient
        XCTAssertEqual(fav.getIngredient(), ingredient, "ingredient not associated with new favorite")
    }
    
// Parse Integration Test: User Registration & Authentication
    func testUserRegistrationAndAuthentication() {
        let username = "testingUser"
        let password = "testingUser"
        let email = "testingUser@gmail.com"
        let registerVC = RegisterView()
        XCTAssertTrue(registerVC.fieldsAreValid(email, username: username, password: password, pwRetyped: password), "valid user fields seen as invalid")
        
        let newUser = registerVC.requestNewUser(email, username: username, password: password, pwRetyped: password) as PFUser?
        XCTAssertNotNil(newUser, "user not generated for validated fields")
        
        if let _ = newUser {
            setUserSession(newUser!)
        }
        XCTAssertTrue(isUserLoggedIn(), "user was unable to log in.")
    }
    
}
