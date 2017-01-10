//
//  String+Ext.swift
//  BinarySwipe
//
//  Created by Macostik on 5/23/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import Foundation
import UIKit


func GUID() -> String {
    return UUID().uuidString
}

extension NSString {
    
    var URL: Foundation.URL? {
        return Foundation.URL(string: self as String)
    }
    var fileURL: Foundation.URL? {
        return Foundation.URL(fileURLWithPath: self as String)
    }
    var smartURL: Foundation.URL? {
        if isExistingFilePath {
            return fileURL
        } else {
            return URL
        }
    }
    var isExistingFilePath: Bool {
        if hasPrefix("http") {
            return false
        }
        return FileManager.default.fileExists(atPath: self as String)
    }
    
    var trim: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    fileprivate static let emailRegex = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
    var isValidEmail: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", NSString.emailRegex)
        return predicate.evaluate(with: lowercased)
    }
    
    var URLQuery: [String:String] {
        
        var parameters = [String:String]()
        for pair in components(separatedBy: "&") {
            let components = pair.components(separatedBy: "=")
            if components.count == 2 {
                parameters[components[0]] = components[1].removingPercentEncoding
            } else {
                continue
            }
        }
        
        return parameters
    }
    
    func heightWithFont(_ font: UIFont, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let height = boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil).height
        return ceil(height)
    }
    
    func clearPhoneNumber() -> String {
        var phone = ""
        for character in (self as String).characters {
            if character == "+" || "0"..."9" ~= character {
                phone.append(character)
            }
        }
        return phone
    }
    
    var ls: String {
        let string = self as String
        return Bundle.main.localizedString(forKey: string, value: string, table: nil)
    }
}
