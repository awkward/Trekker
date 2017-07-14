//
//  PushNotificationTests.swift
//  Trekker
//
//  Created by Rens Verhoeven on 20/03/2017.
//  Copyright © 2017 Awkward. All rights reserved.
//

import XCTest
@testable import Trekker

class PushNotificationTests: TrekkerTestCase {
    
    func testPushNotificationOpen() {
        let payload: [String: [String: String]] = [
            "aps": [
                "body": "Hello, world!"
            ],
            "acme": [
                "action": "kill",
                "message": "Goodbye world!"
            ]
        ]
        
        self.tracker.trackPushNotificationOpen(payload)
        
        if let aps = self.mockService.lastPushNotification?["aps"] as? [String: String] {
            XCTAssert(aps["body"]! == "Hello, world!", "The body key is incorrect from the push notification.")
        } else {
            XCTFail("Aps body missing in last push notification.")
        }
        
        if let custom = self.mockService.lastPushNotification?["acme"] as? [String: String] {
            XCTAssert(custom["action"]! == "kill", "The action is missing from the push notification.")
        } else {
            XCTFail("Custom body missing in last push notification.")
        }
        
        if let lastNotification = self.mockService.lastPushNotification as? [String: [String: String]] {
            XCTAssert(lastNotification.count == payload.count, "The payload the mock service received, should be the same as the payload sent.")
        } else {
            XCTFail("Mock service has invalid push notification format.")
        }
        
    }
    
    func testPushNotificationRegister() {
    
        let pushToken = Data()
        self.tracker.registerForPushNotifications(pushToken)
        
        XCTAssert(self.mockService.pushToken == pushToken, "The push token received by the mock service should be the same as the token given to the tracker.")
    
    }
    
}
