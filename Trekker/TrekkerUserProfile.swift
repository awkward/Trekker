//
//  TrekkerUserProfile.swift
//  Trekker
//
//  Created by Rens Verhoeven on 09-11-15.
//  Copyright © 2017 Awkward. All rights reserved.
//

import Foundation

/// A enumaration of the user's gender.
///
/// - male: Identifies a male user. The rawValue is `Male`.
/// - female: Identifies a female user. The rawValue is `Female`.
/// - unknown: Used when the gender is unknown. The rawValue is `Unknown`.
/// - other: Used when the user doesn't directly identify as a male or female. The rawValue is `Other`.
public enum TrekkerGender: String {
    case male = "Male"
    case female = "Female"
    case unknown = "Unknown"
    case other = "Other"
}

/// This class form an object with a generic representation of a user. Using `customProperties` you can supply additional information.
/// Properties that are left blank, might be removed from the analytics service. Be sure to always give a profile as complete as possible.
open class TrekkerUserProfile: NSObject {

    /// The identifier to identify a user on your own service. If your service uses numbers, convert it to a string before setting.
    open var identifier: String?
    
    /// The firstname of the user.
    open var firstname: String?
    
    /// The lastname of the user.
    open var lastname: String?
    
    //The full name for the user. If it's not set, it will be formed from the first and last name.
    open var fullName: String? {
        get {
            if self.name != nil {
                return self.name!
            }
            if let firstname = self.firstname, let lastname = self.lastname {
                return "\(firstname) \(lastname)"
            }
            if let firstname = self.firstname {
                return firstname
            }
            if let lastname = self.lastname {
                return lastname
            }
            return nil
        }
        set {
            self.name = newValue
        }
    }
    
    /// The email address for the user.
    open var email: String?
    
    /// The gender of the user as a `TrekkerGender`.
    open var gender: TrekkerGender?
    
    /// The date the user registered for your app, if known.
    open var registationDate: Date?
    
    /// Any custom properties that should be added to the profile
    open var customProperties = [String: Any]()
    
    /// This property is set when the user sets an explicit fullName. Otherwise the name is combined from the first and last name
    fileprivate var name: String?
    
    public init(identifier: String? = nil, firstname: String? = nil, lastname: String? = nil, fullName: String? = nil, email: String? = nil) {
        self.identifier = identifier
        self.firstname = firstname
        self.lastname = lastname
        self.name = fullName
        self.email = email
        super.init()
    }
}
