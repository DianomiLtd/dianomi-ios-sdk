//
//  DianomiAdvertStatus.swift
//  
//
// © 2022 Dianomi. All rights reserved.
//

public enum AdvertStatus {
    case created
    case loading
    case loaded
    case rendered
    case failed(AdvertError)
}
