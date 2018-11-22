//
//  Trekker.swift
//  Trekker
//
//  Created by Rens Verhoeven on 06-11-15.
//  Copyright © 2017 Awkward. All rights reserved.
//

import Foundation
import UIKit

/// Trekker is a simple wrapper to send the same event to multiple analytics services. 
/// Use the default tracker on Trekker to get started.
public final class Trekker: NSObject {
    
    /// The shared instance of the default Trekker.
    private static let defaultTrekker = Trekker()
    
    //MARK: - Public configurable or readable variables
    
    /// If the Trekker itself should handle sesstion state updates automaticlly.
    ///
    /// - important: If this is disbale, you are responsible to call the following methods yourself:
    /// - `func startTracking()`
    /// - `func pauseTracking()`
    /// - `func resumeTracking()`
    /// - `func stopTracking()`
    public var automaticStateUpdatingEnabled = true
    
    /// This variable indicates if the if the Trekker has been paused using `func pauseTracking()`.
    fileprivate(set) public var isPaused = false;
    
    /// This variable indicates if the if the Trekker has been started using `func startTracking()`.
    fileprivate(set) public var hasStarted = false;
    
    //MARK: - Private variables
    
    /// This variable holds the time and date the last time `func startTracking()` has been called, this is used in internally.
    fileprivate var startDate: Date?
    
    /// All the analytics services supported by the Trekker. See `func configure(with services: [TrekkerService])` to configure the services.
    fileprivate (set) public var services: [TrekkerService] = [TrekkerDebugService()]
    
    /// The events that should only be send once and have already been sent.
    fileprivate var onceEvents: Set<String> = Set<String>()
    
    //MARK: - Shared instances
    
    /// The default tracker that can be used in most apps, this is a shared instance of the Trekker.
    @objc(defaultTracker)
    public class var `default`: Trekker {
        return Trekker.defaultTrekker
    }
    
    // MARK: - Configuration
    
    /// Configures the Trekker with the given analytics services. This method should be called before "func start()". 
    /// If automatic state updating is enabled, this method will also starts the Trekker.
    ///
    /// - Parameter services: An array of one or more class that implement the `TrekkerService` protocol.
    public func configure(with services: [TrekkerService]) {
        if self.hasStarted {
            print("The Trekker has already been started, configuring the services again is not recommended.")
        }
        self.services = services
        
        if self.automaticStateUpdatingEnabled {
            self.start()
            NotificationCenter.default.addObserver(self, selector: #selector(Trekker.pauseTracking(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(Trekker.resumeTracking(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(Trekker.endTracking(_:)), name: UIApplication.willTerminateNotification, object: nil)
        }
    }
    
    // MARK: - Session state
    
    /// Call this method to notify all services that the tracking should be started. The best place to call this method is in `func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)`.
    public func start() {
        if self.services.count == 0 {
            print("Trekker: No services configured, continueing without services. Be sure to call `configureWithServices:` before startTracking is called.")
        }
        self.hasStarted = true
        self.startDate = Date()
        self.services.forEach { (service) in
            service.start()
        }
    }
    
    /// Call this method to notify all services that the tracking should be paused. The best place to call this method is in `func applicationDidEnterBackground(_ application: UIApplication)`.
    public func pause() {
        self.pauseTracking(nil)
    }
    
    /// This method is used for automatic state updating with NSNotifications. See the configure method.
    @objc fileprivate func pauseTracking(_ notification: Notification?) {
        self.isPaused = true
        self.services.forEach { (service) in
            service.pause()
        }
    }
    
    /// Call this method to notify all service that tracking should continue. The best place to call this method is in `func applicationDidBecomeActive(_ application: UIApplication)`.
    public func resume() {
        self.resumeTracking(nil)
    }
    
    /// This method is used for automatic state updating with NSNotifications. See the configure method.
    @objc fileprivate func resumeTracking(_ notification: Notification?) {
        //UIApplicationDidBecomeActiveNotification is also called when the app has just been started, however we should ignore that so quickly after starting.
        guard let startDate = self.startDate, startDate.timeIntervalSinceNow < -1 else {
            return
        }
        self.isPaused = false
        self.services.forEach { (service) in
            service.resume()
        }
    }
    
    /// Call this method to notify all service that tracking should end. The best place to call this method is in `func applicationWillTerminate(_ application: UIApplication)`.
    public func end() {
        self.endTracking(nil)
    }
    
    /// This method is used for automatic state updating with NSNotifications. See the configure method.
    @objc fileprivate func endTracking(_ notification: Notification?) {
        self.hasStarted = false
        self.onceEvents = Set<String>()
        self.services.forEach { (service) in
            service.stop()
        }
    }
    
}

//MARK: - Tracking of events

extension Trekker {
    
    /// The services that implement the `TrekkerEventAnalytics` protocol.
    private var servicesForEventTracking: [TrekkerEventAnalytics] {
        return self.services.compactMap { (service) -> TrekkerEventAnalytics? in
            return service as? TrekkerEventAnalytics
        }
    }
    
    /// Call this method to send an event to all the registered services that support the `TrekkerEventAnalytics` protocol.
    ///
    /// - Parameter event: The name of the event to send.
    @objc(trackEventName:)
    public func track(event: String) {
        self.track(event: TrekkerEvent(event: event))
    }
    
    /// Call this method to send an event to all the registered services that support the `TrekkerEventAnalytics` protocol. 
    /// But only once in the session of the Trekker, if the app is restarted from scratch, it will track again.
    /// This can be used to only track the first visit of the user to a certain view.
    ///
    /// - Parameter event: The name of the event to send.
    @objc(trackEventNameOnce:)
    public func trackOnce(event: String) {
        self.trackOnce(event: TrekkerEvent(event: event))
    }

    /// Call this method to send an event to all the registered services that support the `TrekkerEventAnalytics` protocol.
    ///
    /// - Parameter event: An TrekkerEvent to send.
    @objc(trackEvent:)
    public func track(event: TrekkerEvent) {
        self.servicesForEventTracking.forEach { (service) in
            let eventName = event.eventNameForService(service)
            service.trackEvent(eventName, withProperties: event.properties)
        }
    }
    
    /// Call this method to send an event to all the registered services that support the `TrekkerEventAnalytics` protocol.
    /// But only once in the session of the Trekker, if the app is restarted from scratch, it will track again. 
    /// The properties will be ignored when checking if the event was already sent.
    /// This can be used to only track the first visit of the user to a certain view.
    ///
    /// - Parameter event: An TrekkerEvent to send.
    @objc(trackEventOnce:)
    public func trackOnce(event: TrekkerEvent) {
        guard !self.onceEvents.contains(event.eventName) else {
            return
        }
        self.onceEvents.insert(event.eventName)
        self.track(event: event)
    }
    
}

// MARK: - Tracking of timed events

extension Trekker {
    
    /// The services that implement the `TrekkerTimedEventAnalytics` protocol.
    private var servicesForTimedEventTracking: [TrekkerTimedEventAnalytics] {
        return self.services.compactMap({ (service) -> TrekkerTimedEventAnalytics? in
            return service as? TrekkerTimedEventAnalytics
        })
    }
    
    /// Tells all the services that implement `TrekkerTimedEventAnalytics` to start timing the event.
    ///
    /// - Parameter event: An TrekkerEvent to send. The properties might be ignored and should be added to the stop method instead.
    public func startTiming(event: TrekkerEvent) {
        self.servicesForTimedEventTracking.forEach { (service) in
            let eventName = event.eventNameForService(service)
            service.startTimingEvent(eventName)
        }
    }
    
    /// Tells all the services that implement `TrekkerTimedEventAnalytics` to stop timing the event.
    ///
    /// - Parameter event: An TrekkerEvent to send.
    public func stopTiming(event: TrekkerEvent) {
        self.servicesForTimedEventTracking.forEach { (service) in
            let eventName = event.eventNameForService(service)
            service.stopTimingEvent(eventName, withProperties: event.properties)
        }
    }
    
}

// MARK: - Super properties for events

extension Trekker {
    
    /// The services that implement the `TrekkerEventSuperPropertiesAnalytics` protocol.
    private var servicesForEventSuperProperties: [TrekkerEventSuperPropertiesAnalytics] {
        return self.services.compactMap({ (service) -> TrekkerEventSuperPropertiesAnalytics? in
            return service as? TrekkerEventSuperPropertiesAnalytics
        })
    }

    /// Registers "super" properties with the analytics services that implement `TrekkerEventSuperPropertiesAnalytics`. 
    /// Super propeeties are properties that are added to every event that is tracked. Check the documentation for the analytics services you use to see if this is supported.
    ///
    /// - Parameter properties: The properties to register.
    public func registerEventSuperProperties(_ properties: [String: Any]) {
        self.servicesForEventSuperProperties.forEach { (service) in
            service.registerEventSuperProperties(properties)
        }
    }

    /// Removes all the super properties for the analytics services that implement `TrekkerEventSuperPropertiesAnalytics`.
    public func clearEventSuperProperties() {
        self.servicesForEventSuperProperties.forEach { (service) in
            service.clearEventSuperProperties()
        }
    }
    
}

// MARK: - Remote notifications

extension Trekker {
    
    /// The services that implement the `TrekkerPushNotificationAnalytics` protocol.
    private var servicesForPushNotifications: [TrekkerPushNotificationAnalytics] {
        return self.services.compactMap { (service) -> TrekkerPushNotificationAnalytics? in
            return service as? TrekkerPushNotificationAnalytics
        }
    }
    
    /// Registers the push notifications push token with services that implement the `TrekkerPushNotificationAnalytics` protocol.
    ///
    /// - Parameter deviceToken: The raw push token.
    public func registerForPushNotifications(_ pushToken: Data) {
        self.servicesForPushNotifications.forEach { (service) in
            service.registerForPushNotifications(pushToken)
        }
    }
    
    /// Call this method when a notification was opnened. This needs to be done from:
    /// `func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])` and `application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)` when using the iOS SDK before iOS 10.
    /// And `func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void)` on iOS 10 when using the notification center API.
    ///
    /// - Parameter payload: The payload of the notification.
    public func trackPushNotificationOpen(_ payload: [AnyHashable: Any]) {
        self.servicesForPushNotifications.forEach { (service) in
            service.trackPushNotificationOpen(payload)
        }
    }
}

// MARK: - User profiling

extension Trekker {
    
    /// The services that implement the `TrekkerUserProfileAnalytics` protocol.
    private var servicesForUserProfiles: [TrekkerUserProfileAnalytics] {
        return self.services.compactMap { (service) -> TrekkerUserProfileAnalytics? in
            return service as? TrekkerUserProfileAnalytics
        }
    }
    
    /// Call this method to identify the user with addtional information. Analytics services that implement `TrekkerUserProfileAnalytics` will receieve a basic profile. 
    /// But can contain more information in the `customProperties` property. Any nil items in the User profile should be removed, so be sure to always fill the user profile.
    ///
    /// - Parameter profile: The profile to identify the user with.
    public func identify(using profile: TrekkerUserProfile) {
        self.servicesForUserProfiles.forEach { (service) in
            service.identify(using: profile)
        }
    }
    
}
