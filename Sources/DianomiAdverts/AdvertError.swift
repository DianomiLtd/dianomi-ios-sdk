//
//  AdvertError.swift
//  
//
// © 2022 Dianomi. All rights reserved.
//

import Foundation

public enum AdvertError: Error {
    case invalidRequest
    case loadingError(Error)
}
