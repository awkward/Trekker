//
//  MockSubclassEvent.swift
//  Trekker
//
//  Created by Rens Verhoeven on 20/03/2017.
//  Copyright © 2017 Awkward. All rights reserved.
//

import UIKit
@testable import Trekker

class MockSubclassEvent: TrekkerEvent {
    
    override func eventNameForService(_ service: TrekkerService) -> String {
        if service.serviceName == "Mock" {
            return self.eventName.lowercased().replacingOccurrences(of: " ", with: "_")
        } else {
            return self.eventName
        }
    }

}
