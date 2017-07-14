//
//  SuperPropertiesTest.swift
//  Trekker
//
//  Created by Rens Verhoeven on 20/03/2017.
//  Copyright © 2017 Awkward. All rights reserved.
//

import XCTest

class SuperPropertiesTest: TrekkerTestCase {
    
    func testRegisteringSuperProperties() {
        
        let properties: [String: Any] = [
            "Locale": "nl",
            "Favorite Pokemon": "Pikachu"
        ]
    
        self.tracker.registerEventSuperProperties(properties)
        
        XCTAssert(self.mockService.eventSuperProperties!["Locale"] as? String == "nl", "Event super properties should be registered with the mock service.")
        XCTAssert(self.mockService.eventSuperProperties!["Favorite Pokemon"] as? String == "Pikachu", "Event super properties should be registered with the mock service.")
        
        let moreProperties: [String: Any] = [
            "Number of books read": 20,
            "Favorite Pokemon": "Squirtle"
        ]
        
        self.tracker.registerEventSuperProperties(moreProperties)
        
        XCTAssert(self.mockService.eventSuperProperties!["Locale"] as? String == "nl", "Previously registered event super properties shouldn't be removed.")
        XCTAssert(self.mockService.eventSuperProperties!["Favorite Pokemon"] as? String == "Squirtle", "Previously registered event super properties should be overwritten if needed.")
        XCTAssert(self.mockService.eventSuperProperties!["Number of books read"] as? Int == 20, "Event super properties should be registered with the mock service.")
        
    }
    
    func testClearSuperProperties() {
        self.tracker.clearEventSuperProperties()
        
        XCTAssert((self.mockService.eventSuperProperties?.count ?? 0) == 0, "All event super properties should be removed!")
    }
    
    
}
