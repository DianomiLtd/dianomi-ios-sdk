//
//  AdvertDelegate.swift
//  
//
// © 2022 Dianomi. All rights reserved.
//

import Foundation

public protocol AdvertDelegate: AnyObject {
    /**
        Use this method to get notified when a loading status if advert is changed
     - Parameter advertView: advert that is being reported
     - Parameter status: status of the ad.
    */
    func didChangeStatus(advertView: DianomiAdvertView, status: AdvertStatus)
}
