//
//  TimedEvents.swift
//  Trekker
//
//  Created by Rens Verhoeven on 20/03/2017.
//  Copyright © 2017 Awkward. All rights reserved.
//

import XCTest
@testable import Trekker

class TimedEvents: TrekkerTestCase {
    
    func testTimedEvent() {
        let event = TrekkerEvent(event: "Image uploading")
        
        Trekker.default.startTiming(event: event)
        
        XCTAssert(self.mockService.trackedEvents(with: event.eventName).count == 0, "The mock service should not have a tracked event already!")
        
        /// Sleep is not 100% accurate, that's why we use 2.9 below when testing the duration.
        sleep(3)
        
        Trekker.default.stopTiming(event: event)
        
        XCTAssert(self.mockService.trackedEvents(with: event.eventName).count == 1, "The mock service should have a tracked event!")
        XCTAssert((self.mockService.trackedEvents(with: event.eventName).first!.properties!["Duration"] as? TimeInterval ?? 0) >= 2.9, "The duratiom should be equal or higher than the elapsed time since the start.")
    }
    
    func testTimedEventWithProperties() {
        let event = TrekkerEvent(event: "Video uploading", properties: ["Filetype": "mp4"])
        
        Trekker.default.startTiming(event: event)
        
        XCTAssert(self.mockService.trackedEvents(with: event.eventName).count == 0, "The mock service should not have a tracked event already!")
        
        /// Sleep is not 100% accurate, that's why we use 2.9 below when testing the duration.
        sleep(3)
        
        Trekker.default.stopTiming(event: event)
        
        XCTAssert(self.mockService.trackedEvents(with: event.eventName).count == 1, "The mock service should have a tracked event!")
        XCTAssert((self.mockService.trackedEvents(with: event.eventName).first!.properties!["Duration"] as? TimeInterval ?? 0) >= 2.9, "The duratiom should be equal or higher than the elapsed time since the start.")
        XCTAssert(self.mockService.trackedEvents(with: event.eventName).first!.properties!["Filetype"] as? String == "mp4", "The event should still have the filetype property.")
    }
    
}
