//
//  AppDelegate.swift
//  Trekker
//
//  Created by Rens Verhoeven on 06-11-15.
//  Copyright © 2017 Awkward. All rights reserved.
//

import UIKit
import Trekker

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //MARK: - Application states

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //let mixpanel = MixpanelService(token: "002b0dd7f191c2cdeee19893e12572fe")
        let debug = TrekkerDebugService()
        
        Trekker.default.configure(with: [debug])
        
        let payload: [AnyHashable: Any] = [
            "aps": [
                "body": "Hello, world!"
            ],
            "acme": [
                "action": "kill",
                "message": "Goodbye world!"
            ]
        ]
        
        Trekker.default.trackPushNotificationOpen(payload)
        
        //If automaticSettingStateUpdatingEnabled is false, start should be called here on any Trekker. This should be done after calling "configureWithServices"
        //Trekker.defaultTracker.startTracking()
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //If automaticSettingStateUpdatingEnabled is false, pause should be called here on any Trekker
        //Trekker.defaultTracker.pauseTracking()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        //If automaticSettingStateUpdatingEnabled is false, resume should be called here on any Trekker
        //Trekker.defaultTracker.resumeTracking()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        //If automaticSettingStateUpdatingEnabled is false, stop should be called here on any Trekker
        //Trekker.defaultTracker.stopTracking()
    }
    
    //MARK: - Push notifications
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        Trekker.default.trackPushNotificationOpen(userInfo)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Trekker.default.registerForPushNotifications(deviceToken)
    }


}

