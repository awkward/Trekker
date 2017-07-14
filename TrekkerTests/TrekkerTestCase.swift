//
//  TrekkerTestCase.swift
//  Trekker
//
//  Created by Rens Verhoeven on 20/03/2017.
//  Copyright © 2017 Awkward. All rights reserved.
//

import XCTest
@testable import Trekker

class TrekkerTestCase: XCTestCase {
    
    let mockService = MockService()
    
    lazy var tracker: Trekker = {
        return Trekker.default
    }()
    
    override func setUp() {
        super.setUp()
        
        self.tracker.automaticStateUpdatingEnabled = false
        self.tracker.configure(with: [self.mockService, EmptyService(), TrekkerDebugService()])
        self.tracker.start()
        
        XCTAssert(self.mockService.hasStarted == true, "The mock service has not been started.")
    }
    
    override func tearDown() {
        self.tracker.end()
        
        if !self.tracker.services.isEmpty {
            XCTAssert(self.mockService.hasStarted == false, "The mock service has not been stopped.")
            XCTAssert(self.mockService.trackedEvents().count == 0, "The mock service has not reset it's tracked events.")
        }
        
        super.tearDown()
        
    }
    
}
