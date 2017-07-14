//
//  UserProfileTests.swift
//  Trekker
//
//  Created by Rens Verhoeven on 20/03/2017.
//  Copyright © 2017 Awkward. All rights reserved.
//

import XCTest
@testable import Trekker

class UserProfileTests: TrekkerTestCase {
    
    func testProfile() {
        let profile = TrekkerUserProfile(identifier: "100", firstname: "Jan", lastname: "Class", fullName: "Class, Jan", email: "jan@example.com")
        profile.gender = .male
        
        self.tracker.identify(using: profile)
        
        XCTAssert(self.mockService.currentProfile.identifier == "100", "The identifier of the user profile is incorrect.")
        XCTAssert(self.mockService.currentProfile.firstname == "Jan", "The first name of the user profile is incorrect.")
        XCTAssert(self.mockService.currentProfile.lastname == "Class", "The last name of the user profile is incorrect.")
        XCTAssert(self.mockService.currentProfile.fullName == "Class, Jan", "The full name of the user profile is incorrect.")
        XCTAssert(self.mockService.currentProfile.email == "jan@example.com", "The email of the user profile is incorrect.")
        XCTAssert(self.mockService.currentProfile.gender == .male, "The gender of the user profile is incorrect.")
        
        /// Change the gender
        profile.gender = .other
        
        self.tracker.identify(using: profile)
        
        XCTAssert(self.mockService.currentProfile.gender == .other, "The user has specified a different gender and should no longer be identified as \(self.mockService.currentProfile.gender!.rawValue)")
        
        /// Change the order of the full name
        profile.fullName = nil
        
        self.tracker.identify(using: profile)
        
        XCTAssert(self.mockService.currentProfile.fullName == "Jan Class", "The user has removed there specific way of writing there name.")
        
        /// Change one of the custom properties
        profile.customProperties = ["Status": "Rich"]
        
        self.tracker.identify(using: profile)
        
        XCTAssert(self.mockService.currentProfile.customProperties.count == 1, "The user has supplied custom properties. these should be reflected on the profile.")
        
        /// Change this first name, remove the last name
        profile.firstname = "Petra"
        profile.lastname = nil
        
        self.tracker.identify(using: profile)
        
        XCTAssert(self.mockService.currentProfile.fullName == "Petra", "The profile no longer has a last name, the full name should be the first name only.")
        
        /// Change this last name, remove the first name
        profile.firstname = nil
        profile.lastname = "Class"
        
        self.tracker.identify(using: profile)
        
        XCTAssert(self.mockService.currentProfile.fullName == "Class", "The profile no longer has a first name, the full name should be the last name only.")

        /// Reset the profile
        let newProfile = TrekkerUserProfile(identifier: "100", firstname: nil, lastname: nil, fullName: nil, email: nil)
    
        self.tracker.identify(using: newProfile)
        
        XCTAssert(self.mockService.currentProfile.identifier == "100", "The profile was reset, but the identifier should be the same.")
        XCTAssert(self.mockService.currentProfile.firstname == nil, "The profile was reset, this property should not be available.")
        XCTAssert(self.mockService.currentProfile.lastname == nil, "The profile was reset, this property should not be available.")
        XCTAssert(self.mockService.currentProfile.fullName == nil, "The profile was reset, this property should not be available.")
        XCTAssert(self.mockService.currentProfile.email == nil, "The profile was reset, this property should not be available.")
        XCTAssert(self.mockService.currentProfile.gender == nil, "The profile was reset, this property should not be available.")
        

        
        
        
    }
    
}
