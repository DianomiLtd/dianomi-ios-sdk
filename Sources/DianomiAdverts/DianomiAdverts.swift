//
//  DianomiAdverts.swift
//  
//
// © 2022 Dianomi. All rights reserved.
//

import Foundation
import OSLog

public class DianomiAdverts {
    
    /// Shard DianomiAdverts singleton for configuring of the DianomiAdvertsSDK
    public static let shared = DianomiAdverts()
    
    public weak var logger: DianomiLogger?
     
    /// Enables debug logging
    public var loggingEnabled: Bool = false {
        didSet {
            log("DianomiAdverts: \(loggingEnabled ? "enabling" : "disabling") logging")
        }
    }
    
    ///  If applies, sets whether the user has consentented / declined
    ///  default is nil (consent status uknown)
    public var consent: String? {
        didSet {
            guard let consent = consent else {
                log("DianomiAdverts: consent unset")
                return
            }
            log("DianomiAdverts: consent set to \(consent)")
        }
    }

    ///  Sets whether the app has overridden system appearance settings for dark mode
    ///  default is nil (appearance mode status is uknown)
    public var appearanceOverride: AppearanceOverride? {
        didSet {
            guard let apearranceOverride = appearanceOverride else {
                log("DianomiAdverts: apearranceOverride unset")
                return
            }
            log("DianomiAdverts: apearranceOverride set to \(apearranceOverride)")
        }
    }
    
    ///  Sets the ID representing user of the app passed in Ad requests
    ///  default is nil (no user ID is set)
    public var userId: String? {
        didSet {
            guard let userId = userId else {
                log("DianomiAdverts: userId unset")
                return
            }
            log("DianomiAdverts: userId set to \(userId)")
        }
    }
    
    ///  Sets the advertising ID to be passed in Ad requests
    ///  default is nil (no advertising ID is set)
    public var advertisingID: String? {
        didSet {
            guard let advertisingID = advertisingID else {
                log("DianomiAdverts: advertisingID unset")
                return
            }
            log("DianomiAdverts: advertisingID set to \(advertisingID)")
        }
    }
    
    /// Logs the string using the best logging function
    internal func log(_ text: String) {
        guard loggingEnabled else { return }

        if #available(iOS 14, *) {
            os_log("%s", log: .adverts, type: .info, text)
        } else {
            NSLog("\(text)")
        }
        
        logger?.log(text)
    }
}

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "DianomiAdverts"

    static let adverts = OSLog(subsystem: subsystem, category: "adverts")
}
