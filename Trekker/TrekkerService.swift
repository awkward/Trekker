//
//  TrekkerService.swift
//  Trekker
//
//  Created by Rens Verhoeven on 06-11-15.
//  Copyright © 2017 Awkward. All rights reserved.
//

import Foundation

/**
This protocol should be implemented by every service that will be used with an instance of `Trekker`. 
To support specific features for analytics tracking, you can implement the following protocols next to `TrekkerService`:
- `TrekkerEventAnalytics` to track events.
- `TrekkerTimedEventAnalytics` to track timed events.
- `TrekkerPushNotificationAnalytics` to track push notification and retrieve the push notification token.
- `TrekkerUserProfileAnalytics` to support identifying the user with some information.
- `TrekkerEventSuperPropertiesAnalytics` to support event super properties, properties that should be added to every (timed)event tracked.
 
- important: `versionString` has to represent the version of the SDK used for the service or a self assigned version if an SDK is not used.
*/
public protocol TrekkerService {

    /// The name of the service, this can be used to identifiy the service in `TrekkerEvent`.
    var serviceName: String { get }
    
    /// The version of the service SDK used.
    var versionString: String { get }
    
    /// Called when the Trekker has been started using `func startTracking()`. Some services can use this to start a session.
    func start()
    
    /// Called when the Trekker has been paused using `func pauseTracking()`. Some services can use this to pause a session or flush the information.
    func pause()
    
    /// Called when the Trekker has been resumed using `func resumeTracking()`. Some services can use this to resume a session.
    func resume()
    
    /// Called when the Trekker has been stopped using `func stopTracking()`. Some services can use this to end a session.
    func stop()

    /// Called when Tracking is opt-in to enable/disable tracking.
    func setTrackingEnabled(_ enabled: Bool)
}

public extension TrekkerService {

    func start() {
        // Empty implementation to make the implementation optional.
    }
    
    func pause() {
        // Empty implementation to make the implementation optional.
    }
    
    func resume() {
        // Empty implementation to make the implementation optional.
    }
    
    func stop() {
        // Empty implementation to make the implementation optional.
    }

    func setTrackingEnabled(_ enabled: Bool) {
        // Empty implementation to make the implementation optional.
    }
}
