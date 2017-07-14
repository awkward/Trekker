//
//  AmplitudeService.swift
//  Beam
//
//  Created by Rens Verhoeven on 18-04-16.
//  Copyright © 2016 Awkward. All rights reserved.
//

import Foundation
import Trekker
import Amplitude

/**
 Adding a service requires to first implement the Amplitude SDK. See these steps: https://github.com/amplitude/Amplitude-iOS#swift
 */

/// An example implementation of Amplitude as an TrekkerService.
/// Supports:
/// - Event analytics
/// - User profiles
/// - Timed analytics (custom implementation)
/// - Super properties (as user properties, see `userPropertiesAsEventSuperProperties` to disable this)
class AmplitudeService: TrekkerService {
    
    var serviceName = "Amplitude"

    var versionString: String {
        return kAMPVersion
    }
    
    let tracker: Amplitude
    
    /// If the amplitude service should use the user properties as event super properties. User properties are still available on every event in the Amplitude web UI.
    var userPropertiesAsEventSuperProperties = true
    
    /// The start date by the name of an event. If the same name starts timing again, it will be overwritten.
    fileprivate var startDatesByEvent: [String: Date] = [String: Date]()
    
    /// Creates the Amplitude analytice service with the given API key.
    ///
    /// - Parameter apiKey: The API key to use for amplitude.
    init(apiKey: String) {
        let amplitude = Amplitude.instance()!
        amplitude.initializeApiKey(apiKey)
        self.tracker = amplitude
    }
    
}

/// MARK: - TrekkerEventAnalytics
extension AmplitudeService: TrekkerEventAnalytics {
    
    func trackEvent(_ event: String, withProperties properties: [String : Any]?) {
        if let properties = properties {
            self.tracker.logEvent(event, withEventProperties: properties)
        } else {
            self.tracker.logEvent(event)
        }
    }
    
}

/// MARK: - TrekkerTimedEventAnalytics
extension AmplitudeService: TrekkerTimedEventAnalytics {
    
    func startTimingEvent(_ event: String) {
        self.startDatesByEvent[event] = Date()
    }
    
    func stopTimingEvent(_ event: String, withProperties properties: [String : Any]?) {
        if let properties = properties {
            var allProperties = properties
            if let startDate = self.startDatesByEvent[event] {
                allProperties["Duration"] = Date().timeIntervalSince(startDate)
            }
            
            self.tracker.logEvent(event, withEventProperties: properties)
        } else {
            var allProperties = [String: Any]()
            if let startDate = self.startDatesByEvent[event] {
                allProperties["Duration"] = Date().timeIntervalSince(startDate)
            }
            self.tracker.logEvent(event, withEventProperties: allProperties)
        }
        if let index = self.startDatesByEvent.index(forKey: event) {
            self.startDatesByEvent.remove(at: index)
        }
    }
}

/// MARK: - TrekkerUserProfileAnalytics
extension AmplitudeService: TrekkerUserProfileAnalytics {
    
    func identify(using profile: TrekkerUserProfile) {
        self.tracker.setUserId(profile.identifier)
        let identify = AMPIdentify()
        if let value = profile.fullName {
            identify.set("Full name", value: value as NSString)
        }
        if let value = profile.firstname {
            identify.set("First name", value: value as NSString)
        }
        if let value = profile.lastname {
            identify.set("Last name", value: value as NSString)
        }
        if let value = profile.gender?.rawValue {
            identify.set("Gender", value: value as NSString)
        }
        if let value = profile.email {
            identify.set("Email", value: value as NSString)
        }
        for (key, value) in profile.customProperties {
            if let object = value as? NSObject {
                identify.set(key, value: object)
            } else {
                NSLog("User property can not be sent to Amplitude because it can not be converted to an NSObject \(key)")
            }
            
        }
        
        self.tracker.identify(identify)
    }
}

// MARK: - TrekkerEventSuperPropertiesAnalytics
extension AmplitudeService: TrekkerEventSuperPropertiesAnalytics {

    func registerEventSuperProperties(_ properties: [String : Any]) {
        guard self.userPropertiesAsEventSuperProperties else {
            return
        }
        self.tracker.setUserProperties(properties)
    }
    
    func clearEventSuperProperties() {
        guard self.userPropertiesAsEventSuperProperties else {
            return
        }
        self.tracker.clearUserProperties()
    }
}
