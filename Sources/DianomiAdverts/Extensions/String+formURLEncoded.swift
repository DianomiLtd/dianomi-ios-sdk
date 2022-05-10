//
//  String+formURLEncoded.swift
//  
//
//  Created by Mirek Petricek on 04/05/2022.
//

import Foundation

extension String {
    static let formUrlencodedAllowedCharacters = CharacterSet(charactersIn: "0123456789" +
                 "abcdefghijklmnopqrstuvwxyz" +
                 "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
                 "-._* ")
    
    /// Encodes a string into "application/x-www-form-urlencoded" format
    public var formUrlencoded: String? {
        let encoded = addingPercentEncoding(withAllowedCharacters: String.formUrlencodedAllowedCharacters)
        return encoded?.replacingOccurrences(of: " ", with: "+") ?? ""
    }
}
