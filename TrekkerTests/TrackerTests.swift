//
//  TrackerTests.swift
//  Trekker
//
//  Created by Rens Verhoeven on 20/03/2017.
//  Copyright © 2017 Awkward. All rights reserved.
//

import XCTest

class TrackerTests: TrekkerTestCase {
    
    func testPause() {
        self.tracker.pause()
        
        XCTAssert(self.mockService.isPaused == true, "The mock service should be paused.")
        
        self.tracker.resume()
        
        /// Note: self.tracker.start() is called in the setup method
        
        XCTAssert(self.mockService.isPaused == true, "The mock service shouldn't be able to resume after just starting.")
        
        sleep(3)
        
        self.tracker.resume()
        
        XCTAssert(self.mockService.isPaused == false, "The mock service should be resumed.")
    }
    
    func testStartWithoutServices() {
        self.tracker.end()
        
        XCTAssert(self.mockService.hasStarted == false, "The mock service should be stopped.")
        
        self.tracker.configure(with: [])
        
        self.tracker.start()
    }
    
    func testConfigureAfterStart() {
        /// Note: the tracker is started in the setup method
        
        self.tracker.configure(with: [])
        
        self.tracker.start()
        
    }
    
    func testStartingWithAutomaticStateUpdates() {
        self.tracker.end()
        
        XCTAssert(self.mockService.hasStarted == false, "The mock service should be stopped.")
        
        self.tracker.automaticStateUpdatingEnabled = true
        
        self.tracker.configure(with: [self.mockService])
        
        XCTAssert(self.mockService.hasStarted == true, "The mock service should be started.")
    }
    
}
