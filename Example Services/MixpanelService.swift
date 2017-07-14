//
//  MixpanelService.swift
//  beam
//
//  Created by Rens Verhoeven on 09-11-15.
//  Copyright © 2015 Awkward. All rights reserved.
//

import Foundation
import Trekker
import Mixpanel

/**
 Adding a service requires to first implement the Mixpanel SDK. See these steps: https://mixpanel.com/help/reference/swift
 */

/// An example implementation of Mixpanel as an TrekkerService.
/// Supports:
/// - Event analytics
/// - User profiles
/// - Timed analytics
/// - Push notifications
/// - Super properties
class MixpanelService: NSObject, TrekkerService {
    
    var serviceName = "Mixpanel"
    
    var versionString: String {
        return self.mixpanelTracker?.libVersion() ?? "1.0"
    }
    
    var mixpanelTracker: Mixpanel!
    
    /// Creates the Amplitude analytice service with the given Mixpanel token.
    ///
    /// - Parameter apiKey: The token for mixpanel.
    init(token: String) {
        super.init()
        self.mixpanelTracker = Mixpanel.sharedInstance(withToken: token)
    }
    
}

/// MARK: - TrekkerEventAnalytics
extension MixpanelService: TrekkerEventAnalytics {
    
    func trackEvent(_ event: String, withProperties properties: [String : Any]?) {
        self.mixpanelTracker.track(event, properties: properties)
    }
    
}

/// MARK: - TrekkerTimedEventAnalytics
extension MixpanelService: TrekkerTimedEventAnalytics {
    
    func startTimingEvent(_ event: String) {
        self.mixpanelTracker.timeEvent(event)
    }
    
    func stopTimingEvent(_ event: String, withProperties properties: [String : Any]?) {
        self.trackEvent(event, withProperties: properties)
    }
    
}

/// MARK: - TrekkerPushNotificationAnalytics
extension MixpanelService: TrekkerPushNotificationAnalytics {
    
    func trackPushNotificationOpen(_ payload: [AnyHashable: Any]) {
        self.mixpanelTracker.trackPushNotification(payload)
    }
    
    func registerForPushNotifications(_ deviceToken: Data) {
        self.mixpanelTracker.people.addPushDeviceToken(deviceToken)
    }
    
}

/// MARK: - TrekkerUserProfileAnalytics
extension MixpanelService: TrekkerUserProfileAnalytics {
    
    func identify(using profile: TrekkerUserProfile) {
        var identifier = profile.identifier
        if identifier == nil {
            identifier = profile.email
        }
        if let identifier = identifier {
            self.mixpanelTracker.identify(identifier)
            var properties = [String: Any]()

            if let value = profile.firstname {
                properties["$first_name"] = value
            }

            if let value = profile.lastname {
                properties["$last_name"] = value
            }

            if let value = profile.fullName {
                properties["$name"] = value
            }

            if let value = profile.email {
                properties["$email"] = value
            }

            if let value = profile.registationDate {
                properties["$created"] = value
            }

            if let value = profile.gender {
                properties["Gender"] = value.rawValue
            }

            //Append the last custom properties
            for (key, property) in profile.customProperties {
                properties[key] = property
            }

            self.mixpanelTracker.people.set(properties)
        }
    }

}

/// MARK: - TrekkerEventSuperPropertiesAnalytics
extension MixpanelService: TrekkerEventSuperPropertiesAnalytics {
    
    func registerEventSuperProperties(_ properties: [String : Any]) {
        self.mixpanelTracker.registerSuperProperties(properties)
    }
    
    func clearEventSuperProperties() {
        self.mixpanelTracker.clearSuperProperties()
    }
    
}
