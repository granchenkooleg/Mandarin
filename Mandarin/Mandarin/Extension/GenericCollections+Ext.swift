//
//  GenericCollections+Ext.swift
//  BinarySwipe
//
//  Created by Macostik on 5/23/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return (index >= 0 && index < count) ? self[index] : nil
    }
}

extension Array where Element: Equatable {
    
    mutating func remove(_ element: Element) {
        if let index = index(of: element) {
            self.remove(at: index)
        }
    }
}

extension Collection {
    
    func all(_ enumerator: (Iterator.Element) -> Void) {
        for element in self {
            enumerator(element)
        }
    }
    
    subscript (includeElement: (Iterator.Element) -> Bool) -> Iterator.Element? {
        for element in self where includeElement(element) == true {
            return element
        }
        return nil
    }
}

extension Dictionary {
    
    func get<T>(_ key: Key) -> T? {
        return self[key] as? T
    }
}
