//
//  TrekkerEvent.swift
//  Trekker
//
//  Created by Rens Verhoeven on 06-11-15.
//  Copyright © 2017 Awkward. All rights reserved.
//

import Foundation


/// An object to send to Trekker to track an event.
/// This object can be subclassed to use specific name for certain services.
open class TrekkerEvent: NSObject {
    
    /// The name of the event, alphanumeric characters, dashes and spaces are allowed.
    open let eventName: String
    
    /// The properties to send with the event
    open let properties: [String: Any]?
    
    /// Creates an event with the given name and properties.
    ///
    /// - Parameters:
    ///   - event: The name of the event.
    ///   - properties: The associated of the event.
    public init(event: String, properties: [String: Any]? = nil) {
        self.eventName = event
        self.properties = properties
        super.init()
    }
    
    /// This method can be used in a subclass of TrekkerEvent to supply a custom name to a specific service. This can be used to return predefined names or modify the given event name to include underscores, strip characters etc.
    ///
    /// - Parameter service: The service which is requesting the name. You can use the `serviceName` property to identify the service.
    /// - Returns: The name of the event to send to the service.
    internal func eventNameForService(_ service: TrekkerService) -> String {
        return self.eventName
    }
}
