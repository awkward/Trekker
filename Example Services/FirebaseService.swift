//
//  FirebaseService.swift
//  ExampleAnalyticsServices
//
//  Created by Rens Verhoeven on 22/03/2017.
//  Copyright © 2017 awkward. All rights reserved.
//

import Foundation
import Trekker
import Firebase

/**
 Adding a service requires to first implement the Firebase SDK. See these steps: https://firebase.google.com/docs/analytics/ios/start
 
 **Important Note: ** Firebase requires all event and property names to be lowercase without spaces.
*/

/// An example implementation of Firebase as an TrekkerService.
/// **Important Note: ** Firebase requires all event and property names to be lowercase without spaces.
///
/// Supports:
/// - Event analytics
/// - User profiles (requires pre-registration on Firebase console)
/// - Timed analytics (custom implementation)
class FirebaseService: TrekkerService {
    
    var serviceName = "Firebase"
    
    var versionString: String {
        return "1.0"
    }
    
    /// The start date by the name of an event. If the same name starts timing again, it will be overwritten.
    fileprivate var startDatesByEvent: [String: Date] = [String: Date]()
    
    /// Creates the Firebase analytice service.
    init() {
        
    }
    
    /// Converts the property from [String: Any] to [String: NSObject]. 
    /// Also turns the keys into lowercase without spaces. This is required by firebase.
    ///
    /// - Parameter properties: The properties that should be converted.
    /// - Returns: The properties converted to [String: NSObject] with lowercase keys.
    fileprivate func convertProperties(_ properties: [String: Any]?) -> [String: NSObject]? {
        guard let properties = properties else {
            return nil
        }
        var newProperties = [String: NSObject]()
        for (key, value) in properties {
            let newKey = key.lowercased().replacingOccurrences(of: " ", with: "_")
            if let newValue = value as? NSObject {
                newProperties[newKey] = newValue
            } else {
                NSLog("Property for key \(key) could not be sent to firebase because the value type is not supported")
            }
        }
        return newProperties
    }
    
    
    /// Converts the event name to lower case without spaces.
    ///
    /// - Parameter event: The evenr name to convert.
    /// - Returns: The converted event name.
    fileprivate func convertEventName(_ event: String) -> String {
        return event.lowercased().replacingOccurrences(of: " ", with: "_")
    }
    
}

/// MARK: - TrekkerEventAnalytics
extension FirebaseService: TrekkerEventAnalytics {
    
    func trackEvent(_ event: String, withProperties properties: [String : Any]?) {
        FIRAnalytics.logEvent(withName: self.convertEventName(event), parameters: self.convertProperties(properties))
    }
    
}

/// MARK: - TrekkerTimedEventAnalytics
extension FirebaseService: TrekkerTimedEventAnalytics {
    
    func startTimingEvent(_ event: String) {
        self.startDatesByEvent[event] = Date()
    }
    
    func stopTimingEvent(_ event: String, withProperties properties: [String : Any]?) {
        if let properties = properties {
            var allProperties = properties
            if let startDate = self.startDatesByEvent[event] {
                allProperties["Duration"] = Date().timeIntervalSince(startDate)
            }
            FIRAnalytics.logEvent(withName:  self.convertEventName(event), parameters: self.convertProperties(properties))
        } else {
            var allProperties = [String: Any]()
            if let startDate = self.startDatesByEvent[event] {
                allProperties["Duration"] = Date().timeIntervalSince(startDate)
            }
            FIRAnalytics.logEvent(withName:  self.convertEventName(event), parameters: self.convertProperties(properties))
        }
        if let index = self.startDatesByEvent.index(forKey: event) {
            self.startDatesByEvent.remove(at: index)
        }
    }
}

/// MARK: - TrekkerUserProfileAnalytics
extension FirebaseService: TrekkerUserProfileAnalytics {
    
    func identify(using profile: TrekkerUserProfile) {
        FIRAnalytics.setUserID(profile.identifier)
        if let value = profile.fullName {
            FIRAnalytics.setUserPropertyString(value, forName: "full_name")
        }
        if let value = profile.firstname {
            FIRAnalytics.setUserPropertyString(value, forName: "first_name")
        }
        if let value = profile.lastname {
            FIRAnalytics.setUserPropertyString(value, forName: "last_name")
        }
        if let value = profile.gender?.rawValue {
            FIRAnalytics.setUserPropertyString(value, forName: "gender")
        }
        if let value = profile.email {
            FIRAnalytics.setUserPropertyString(value, forName: "email")
        }
        if let properties = self.convertProperties(profile.customProperties) {
            for (key, value) in properties {
                if let string = value as? String {
                    FIRAnalytics.setUserPropertyString(string, forName: key)
                } else {
                    NSLog("User property can not be sent to firebase because it can not be converted to a string \(key)")
                }
                
            }
        }
        
    }
}
