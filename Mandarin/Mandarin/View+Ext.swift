//
//  View+Ext.swift
//  BinarySwipe
//
//  Created by Macostik on 5/23/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

func animate(_ animated: Bool = true, duration: TimeInterval = 0.3, curve: UIViewAnimationCurve = .easeInOut, animations: () -> ()) {
    if animated {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(curve)
        UIView.setAnimationBeginsFromCurrentState(true)
    }
    animations()
    if animated {
        UIView.commitAnimations()
    }
}

extension UIView {
    
    var x: CGFloat {
        set { frame.origin.x = newValue }
        get { return frame.origin.x }
    }
    
    var y: CGFloat {
        set { frame.origin.y = newValue }
        get { return frame.origin.y }
    }
    
    var width: CGFloat {
        set { frame.size.width = newValue }
        get { return frame.size.width }
    }
    
    var height: CGFloat {
        set { frame.size.height = newValue }
        get { return frame.size.height }
    }
    
    var size: CGSize {
        set { frame.size = newValue }
        get { return frame.size }
    }
    
    var centerBoundary: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    func add<T: UIView>(_ subview: T) -> T {
        addSubview(subview)
        return subview
    }
    
    @discardableResult func add<T: UIView>(_ subview: T, _ layout: (_ make: ConstraintMaker) -> Void) -> T {
        addSubview(subview)
        subview.snp.makeConstraints(layout)
        return subview
    }
    
    func forceLayout() {
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: - Regular Animation
    
    class func performAnimated( _ animated: Bool, animation: (Void) -> Void) {
        if animated {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
        }
        animation()
        if animated {
            UIView.commitAnimations()
        }
    }
    
    func setAlpha(_ alpha: CGFloat, animated: Bool) {
        UIView.performAnimated(animated) { self.alpha = alpha }
    }
    
    func setTransform(_ transform: CGAffineTransform, animated: Bool) {
        UIView.performAnimated(animated) { self.transform = transform }
    }
    
    func setBackgroundColor(_ backgroundColor: UIColor, animated: Bool) {
        UIView.performAnimated(animated) { self.backgroundColor = backgroundColor }
    }
    
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        for subView in self.subviews {
            if let firstResponder = subView.findFirstResponder() {
                return firstResponder
            }
        }
        return nil
    }
    
    // MARK: - QuartzCore
    
    @IBInspectable var borderColor: UIColor? {
        set { layer.borderColor = newValue?.cgColor }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color);
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }
    
    @IBInspectable var circled: Bool {
        set {
            cornerRadius = newValue ? bounds.height/2.0 : 0
            Dispatch.mainQueue.async {
                self.cornerRadius = newValue ? self.bounds.height/2.0 : 0
            }
        }
        get {
            return cornerRadius == bounds.height/2.0
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        set { layer.shadowColor = newValue?.cgColor }
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        set { layer.shadowOffset = newValue }
        get { return layer.shadowOffset }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set { layer.shadowOpacity = newValue }
        get { return layer.opacity }
    }
}

extension UIButton {
    
    var active: Bool {
        set { setActive(newValue, animated: false) }
        get { return alpha > 0.5 && isUserInteractionEnabled }
    }
    
    func setActive(_ active: Bool, animated: Bool) {
        setAlpha(active ? 1.0 : 0.5, animated: animated)
        isUserInteractionEnabled = active
    }
    
    func addTarget(_ target: AnyObject?, touchUpInside: Selector) {
        addTarget(target, action: touchUpInside, for: .touchUpInside)
    }
}
