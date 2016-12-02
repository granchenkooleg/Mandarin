//
//  Dispatch.swift
//  BinarySwipe
//
//  Created by Macostik on 5/23/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import Foundation
import UIKit

struct Dispatch {
    
    static let mainQueue = Dispatch(queue: DispatchQueue.main)
    
    static let defaultQueue = Dispatch(queue: DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default))
    
    static let backgroundQueue = Dispatch(queue: DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background))
    
    fileprivate var queue: DispatchQueue
    
    func sync(_ block: ((Void) -> Void)?) {
        if let block = block {
            queue.sync(execute: block)
        }
    }
    
    func async(_ block: ((Void) -> Void)?) {
        if let block = block {
            queue.async(execute: block)
        }
    }
    
    fileprivate static let delayMultiplier = Float(NSEC_PER_SEC)
    
    func after(_ delay: Float, block: ((Void) -> Void)?) {
        if let block = block {
            queue.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Dispatch.delayMultiplier)) / Double(NSEC_PER_SEC), execute: block)
        }
    }
    
    func fetch<T>(_ block: @escaping ((Void) -> T), completion: @escaping ((T) -> Void)) {
        async {
            let object = block()
            Dispatch.mainQueue.async({ completion(object) })
        }
    }
    
    static func sleep<T>(_ block: (_ awake: (T?) -> ()) -> ()) -> T? {
        let semaphore = DispatchSemaphore(value: 0)
        var value: T?
        block({
            value = $0
            semaphore.signal()
        })
        semaphore.wait(timeout: DispatchTime.distantFuture)
        return value
    }
}

final class DispatchTask {
    
    var block: ((Void) -> Void)?
    
    init(_ delay: Float = 0, _ block: @escaping (Void) -> Void) {
        self.block = block
        Dispatch.mainQueue.after(delay) { [weak self] () -> Void in
            if let block = self?.block {
                block()
            }
        }
    }
    
    func cancel() {
        block = nil
    }
}
