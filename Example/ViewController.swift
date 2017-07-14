//
//  ViewController.swift
//  Trekker
//
//  Created by Rens Verhoeven on 06-11-15.
//  Copyright © 2017 Awkward. All rights reserved.
//

import UIKit
import Trekker

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tracker = Trekker.default
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                tracker.track(event: TrekkerEvent(event: "Opened gallery"))
            case 1:
                tracker.startTiming(event: TrekkerEvent(event: "Using mediaview"))
            case 2:
                tracker.stopTiming(event: TrekkerEvent(event: "Using mediaview"))
            default:
                break
            }
        } else if indexPath.section == 1 {
            let properties = ["Number of images":50,"Contains NSFW images":true] as [String : Any]
            switch indexPath.row {
            case 0:
                tracker.track(event: TrekkerEvent(event: "Opened gallery",properties: properties))
            case 1:
                tracker.startTiming(event: TrekkerEvent(event: "Using mediaview", properties: properties))
            case 2:
                tracker.stopTiming(event: TrekkerEvent(event: "Using mediaview", properties: properties))
            default:
                break
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                self.identifyRensUserProfile()
            case 1:
                self.identifyKlaasJanUserProfile()
            case 2:
                self.identiftyJanKlaassenUserProfile()
            default:
                break
            }
        } else if indexPath.section == 3 {
            switch indexPath.row {
            case 0:
                Trekker.default.registerEventSuperProperties(["Super Property 1": true, "Super Property 2": UIDevice.current.name])
            case 1:
                Trekker.default.clearEventSuperProperties()
            default:
                break
            }
        }
    }
    
    func identifyRensUserProfile() {
        let profile = TrekkerUserProfile()
        profile.firstname = "Rens"
        profile.lastname = "Verhoeven"
        profile.email = "rens@rens.rens"
        profile.gender = .male
        Trekker.default.identify(using: profile)
    }
    
    func identifyKlaasJanUserProfile() {
        let profile = TrekkerUserProfile(identifier: "4hsh2sha3")
        profile.firstname = "Klaas"
        profile.lastname = "Jan"
        profile.fullName = "Klaas van Jan"
        profile.email = "klaas@klaasjan.jan"
        profile.gender = .other
        profile.customProperties = ["Tester":false]
        Trekker.default.identify(using: profile)
    }
    
    func identiftyJanKlaassenUserProfile() {
        let fullName = "Jan Klaassen"
        let email = "j.klaassen@nederland.bv"
        let identifier = "214312412"
        let profile = TrekkerUserProfile(identifier: identifier, firstname: nil, lastname: nil, fullName: fullName, email: email)
        Trekker.default.identify(using: profile)
    }

}

