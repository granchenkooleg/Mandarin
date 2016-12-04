//
//  Constants.swift
//  BinarySwipe
//
//  Created by Macostik on 5/23/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let pixelSize: CGFloat = 1.0
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    static let screenHeight: CGFloat = UIScreen.main.bounds.height
    static let isPhone: Bool = UI_USER_INTERFACE_IDIOM() == .phone
    static let groupIdentifier = "group.com.EP.BinarySwipe"
    static let baseURLString = "http://bez-paketov.ru/api/"
    static let FBClientID = "840339496099378"
    static let FBClientSecret = "a0ef27eda5e14c9981dc5caefd163da5"
    static let videoLinkID = ""
    static let amountTitleArray = ["$25", "$50", "$75", "$100", "$200", "$500", "$750", "$1000"]
}

typealias Block = (Void) -> Void
typealias ObjectBlock = (AnyObject?) -> Void
typealias FailureBlock = (NSError?) -> Void
typealias BooleanBlock = (Bool) -> Void

extension URL {
    
    static func groupContainer() -> URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.groupIdentifier) ?? documents()
    }
    
    static func documents() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? URL(fileURLWithPath: "")
    }
}
