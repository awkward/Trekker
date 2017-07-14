//
//  EmptyService.swift
//  Trekker
//
//  Created by Rens Verhoeven on 20/03/2017.
//  Copyright © 2017 Awkward. All rights reserved.
//

import UIKit
@testable import Trekker

class EmptyService: NSObject, TrekkerService {

    var serviceName: String {
        return "Empty"
    }
    
    var versionString: String {
        return "1.0"
    }
    
}

extension EmptyService: TrekkerPushNotificationAnalytics {

    func registerForPushNotifications(_ pushToken: Data) {
        //We are an empty service, so we don't implement this!
    }
    
}
