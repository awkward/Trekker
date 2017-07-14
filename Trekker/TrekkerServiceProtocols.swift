//
//  TrekkerServiceProtocols.swift
//  Trekker
//
//  Created by Rens Verhoeven on 06-11-15.
//  Copyright © 2017 Awkward. All rights reserved.
//

import Foundation

//MARK: - Events

/// This protocol should be implemented by every service that supports the tracking of events.
public protocol TrekkerEventAnalytics: TrekkerService {
    
    /**
     This method will be called when Trekker is requested to track an event.
    
     - parameters:
        - event: The name of the event, this can contain other characters than just alphanumeric characters
        - properties: The properties to send with the event. **This will not contain the super properties**. These should be added by the service or service's SDK themselves.
     */
    
    /// Called when Trekker receives an event.
    ///
    /// - Parameters:
    ///   - event: The name of the event that was received. This can contain anything including spaces and capital letters.
    ///   - properties: The properties associated with this event, these do not include the super properties. The implementation of the service is responsible for managing the super properties.
    func trackEvent(_ event: String, withProperties properties: [String: Any]?)
}

//MARK: - Timed Events

/// This protocol should be implemented by every service that supports tracking of events that log a duration.
public protocol TrekkerTimedEventAnalytics: TrekkerService {
    
    /// This method will be called when Trekker is requested to start timing an event. The SDK or service is resposinsible for handling the actual timing of the event.
    ///
    /// - Parameter event: The name of the event that was received. This can contain anything including spaces and capital letters.
    func startTimingEvent(_ event: String)
    
    /// This method will be called when Trekker is requested to stop timing an event. The SDK or service is resposinsible for handling the actual timing of the event.
    ///
    /// - Parameters:
    ///   - event: The name of the event that was received. This can contain anything including spaces and capital letters.
    ///   - properties: The properties associated with this event, these do not include the super properties. The implementation of the service is responsible for managing the super properties.
    func stopTimingEvent(_ event: String, withProperties properties: [String: Any]?)
    
}

//MARK: - Push Notifications

/// This protocol should be implemented by every service that suppports push notifications. Or tracking the opening of push notifications.
public protocol TrekkerPushNotificationAnalytics: TrekkerService {
    
    /// Passes the push token to the given service. This token is the raw token given by `func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)`
    ///
    /// - Parameter pushToken: Data of the push token. Can be converted into a string if needed.
    func registerForPushNotifications(_ pushToken: Data)
    
    /// Called when a remote notification is received when the app is open or when the app is opened with a remote notification. The person implementing Trekker is responsible for implementing this.
    ///
    /// - Parameter payload: The payload of the notification, contains the APS body and the custom body.
    func trackPushNotificationOpen(_ payload: [AnyHashable: Any])
}

extension TrekkerPushNotificationAnalytics {
    
    public func trackPushNotificationOpen(_ payload: [AnyHashable: Any]) {
        // Empty implementation to make the implementation optional.
    }
}

//MARK: - User Profile

/// This protocol should be implemented by every service that implements user profiles, which can contain the user's personal details.
public protocol TrekkerUserProfileAnalytics: TrekkerService {
    
    /// Called to identify the user on an analytics service.
    ///
    /// - Parameter profile: A profile of the user, with a number of generic properties.
    func identify(using profile: TrekkerUserProfile)
}

//MARK - Super Properties

/// This protocol should be implemented by every service that supports super properties, properties that are sent with every event and/or profile.
public protocol TrekkerEventSuperPropertiesAnalytics: TrekkerService {

    /// Called to register a set of super propeties with the service. Note that the service itself is responsible for managing the super properties, including saving to disk.
    ///
    /// - Parameter properties: The super properties for the given service.
    func registerEventSuperProperties(_ properties: [String: Any])
    
    /// Should remove all the registered super properties.
    func clearEventSuperProperties()
}
