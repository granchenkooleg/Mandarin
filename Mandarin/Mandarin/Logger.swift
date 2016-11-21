//
//  BaseViewController.swift
//  BinarySwipe
//
//  Created by Macostik on 5/23/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import UIKit

extension UIApplicationState {
    func displayName() -> String {
        switch self {
        case .active: return "active"
        case .inactive: return "inactive"
        case .background: return "in background"
        }
    }
}

struct Logger {
    
    static let logglyDestination = SlimLogglyDestination()
    
    static func configure() {
        Slim.addLogDestination(logglyDestination)
    }
    
    enum LogColor: String {
        case Default = "fg255,255,255;"
        case Yellow = "fg219,219,110;"
        case Green = "fg107,190,31;"
        case Red = "fg201,91,91;"
        case Blue = "fg0,204,204;"
        case Orange = "fg234,117,69;"
    }
    
    fileprivate static let Escape = "\u{001b}["
    
    static func debugLog(_ string: @autoclosure () -> String, color: LogColor = .Default, filename: String = #file, line: Int = #line) {
        #if DEBUG
            Slim.debug("\(Escape)\(color.rawValue)\n\(string())\n\n\(Escape);", filename: filename, line: line)
        #endif
    }
    
    static func log<T>(_ message: @autoclosure () -> T, color: LogColor = .Default, filename: String = #file, line: Int = #line) {
        #if DEBUG
            Slim.debug("\(Escape)\(color.rawValue)\n\(message())\n\n\(Escape);", filename: filename, line: line)
        #else
            Slim.info(message, filename: filename, line: line)
        #endif
    }
}

