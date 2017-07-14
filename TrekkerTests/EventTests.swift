//
//  EventTests.swift
//  Trekker
//
//  Created by Rens Verhoeven on 20/03/2017.
//  Copyright © 2017 Awkward. All rights reserved.
//

import XCTest
@testable import Trekker

class EventTests: TrekkerTestCase {
    
    func testEventTracking() {
        self.tracker.track(event: MockSubclassEvent(event: "Register User"))
        
        XCTAssert(self.mockService.trackedEvents().first!.eventName == "register_user", "The name of the mock subclassed event should be lowercase and without spaces.")
        
        self.tracker.track(event: "Login using email")
        
        XCTAssert(self.mockService.trackedEvents()[1].eventName == "Login using email", "The event name of the second event is incorrect.")
    }
    
    func testTrackOnce() {
        self.tracker.trackOnce(event: "Test event")
        self.tracker.trackOnce(event: "Test event")
        
        XCTAssert(self.mockService.trackedEvents(with: "Test event").count == 1, "trackOnce should only track an event once.")
        
        self.tracker.trackOnce(event: "Test event 2")
        self.tracker.trackOnce(event: "Test event 2")
        
        XCTAssert(self.mockService.trackedEvents().count == 2, "After doing 2 sets of 2 identical trackOnce events, should result in 2 events tracked in total.")
        
        self.tracker.trackOnce(event: TrekkerEvent(event: "Test event 3", properties: ["property": "test"]))
        self.tracker.trackOnce(event: TrekkerEvent(event: "Test event 3", properties: ["property": "test", "property 2": "test"]))
        
        XCTAssert(self.mockService.trackedEvents().count == 3, "After doing 3 sets of 2 identical trackOnce events, should result in 3 events tracked in total.")
        XCTAssert(self.mockService.trackedEvents(with: "Test event 3").first!.properties!["property 2"] == nil, "Events that are tracked once should only send the first event.")
        
    }
    

    
}
