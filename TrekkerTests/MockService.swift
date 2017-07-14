//
//  MockService.swift
//  Trekker
//
//  Created by Rens Verhoeven on 20/03/2017.
//  Copyright © 2017 Awkward. All rights reserved.
//

import UIKit
@testable import Trekker

class MockService: NSObject, TrekkerService {

    public var hasStarted = false
    
    public var isPaused = false
    
    fileprivate var trackedEvents: [TrekkerEvent] = [TrekkerEvent]()
    
    public var currentProfile = TrekkerUserProfile()
    
    public var lastPushNotification: [AnyHashable: Any]?
    
    public var pushToken: Data?
    
    public var eventSuperProperties: [String: Any]?
    
    public var startDatesByEvent: [String: Date] = [String: Date]()
    
    /// The name of the service, this can be used to identifiy the service in `TrekkerEvent`.
    var serviceName: String {
        return "Mock"
    }
    
    /// The version of the service SDK used.
    var versionString: String {
        return "1.0"
    }
    
    /// Called when the Trekker has been started using `func startTracking()`. Some services can use this to start a session.
    func start() {
        self.hasStarted = true
    }
    
    /// Called when the Trekker has been paused using `func pauseTracking()`. Some services can use this to pause a session or flush the information.
    func pause() {
        self.isPaused = true
    }
    
    /// Called when the Trekker has been resumed using `func resumeTracking()`. Some services can use this to resume a session.
    func resume() {
        self.isPaused = false
    }
    
    /// Called when the Trekker has been stopped using `func stopTracking()`. Some services can use this to end a session.
    func stop() {
        self.hasStarted = false
        self.trackedEvents.removeAll()
    }
    
    func trackedEvents(with name: String? = nil) -> [TrekkerEvent] {
        guard let name = name else {
            return self.trackedEvents
        }
        return self.trackedEvents.filter { (event) -> Bool in
            return event.eventName == name
        }
    }
    
    func lastEvent(with name: String) -> TrekkerEvent? {
        return self.trackedEvents(with: name).last
    }
    
}

extension MockService: TrekkerEventAnalytics {
    
    func trackEvent(_ event: String, withProperties properties: [String : Any]?) {
        self.trackedEvents.append(TrekkerEvent(event: event, properties: properties))
    }
    
}

extension MockService: TrekkerUserProfileAnalytics {
    
    func identify(using profile: TrekkerUserProfile) {
        self.currentProfile.identifier = profile.identifier
        self.currentProfile.firstname = profile.firstname
        self.currentProfile.lastname = profile.lastname
        self.currentProfile.email = profile.email
        self.currentProfile.fullName = profile.fullName
        self.currentProfile.gender = profile.gender
        self.currentProfile.customProperties = profile.customProperties
    }
    
}

extension MockService: TrekkerEventSuperPropertiesAnalytics {

    func registerEventSuperProperties(_ properties: [String : Any]) {
        self.eventSuperProperties = self.mergedProperties(self.eventSuperProperties, secondProperties: properties)
    }
    
    func clearEventSuperProperties() {
        self.eventSuperProperties?.removeAll()
    }
    
    fileprivate func mergedProperties(_ firstProperties: [String: Any]?, secondProperties: [String: Any]?) -> [String: Any]? {
        var mergedProperties = [String: Any]()
        if let properties = firstProperties {
            for (key, value) in properties {
                mergedProperties[key] = value
            }
        }
        if let properties = secondProperties {
            for (key, value) in properties {
                mergedProperties[key] = value
            }
        }
        if mergedProperties.count > 0 {
            return mergedProperties
        }
        return nil
    }
}

extension MockService: TrekkerPushNotificationAnalytics {
    
    func registerForPushNotifications(_ pushToken: Data) {
        self.pushToken = pushToken
    }

    func trackPushNotificationOpen(_ payload: [AnyHashable : Any]) {
        self.lastPushNotification = payload
    }
    
    
}

extension MockService: TrekkerTimedEventAnalytics {
    
    func startTimingEvent(_ event: String) {
        self.startDatesByEvent[event] = Date()
    }
    
    func stopTimingEvent(_ event: String, withProperties properties: [String : Any]?) {
        let trackerEvent: TrekkerEvent
        
        if let startDate = self.startDatesByEvent[event] {
            trackerEvent = TrekkerEvent(event: event, properties: self.mergedProperties(properties, secondProperties: ["Duration": Date().timeIntervalSince(startDate)]))
        } else {
            trackerEvent = TrekkerEvent(event: event, properties: properties)
           
        }
        self.trackedEvents.append(trackerEvent)
    }

}
