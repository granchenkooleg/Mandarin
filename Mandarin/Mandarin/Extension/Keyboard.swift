//
//  Keyboard.swift
//  Bezpaketov
//
//  Created by Oleg on 5/23/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import UIKit

@objc protocol KeyboardNotifying {
    @objc optional func keyboardWillShow(_ keyboard: Keyboard)
    @objc optional func keyboardDidShow(_ keyboard: Keyboard)
    @objc optional func keyboardWillHide(_ keyboard: Keyboard)
    @objc optional func keyboardDidHide(_ keyboard: Keyboard)
}

class Keyboard: Notifier {
    
    static let keyboard = Keyboard()
    
    var height: CGFloat = 0
    var animationDuration: TimeInterval = 0
    var animationCurve: UIViewAnimationCurve = .linear
    var isShown = false
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Keyboard.tap(_:)))
    
    override init() {
        super.init()
        let center = NotificationCenter.default
        let queue = OperationQueue.main
        center.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: queue, using: keyboardWillShow)
        center.addObserver(forName: NSNotification.Name.UIKeyboardDidShow, object: nil, queue: queue, using: keyboardDidShow)
        center.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: queue, using: keyboardWillHide)
        center.addObserver(forName: NSNotification.Name.UIKeyboardDidHide, object: nil, queue: queue, using: keyboardDidHide)
    }
    
    fileprivate func fetchKeyboardAnimationMetadata(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo
        animationDuration = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
        if let curve = userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Int {
            animationCurve = UIViewAnimationCurve(rawValue: curve) ?? .linear
        } else {
            animationCurve = .linear
        }
    }
    
    fileprivate func fetchKeyboardMetadata(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo
        let rect = (userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        height = rect?.size.height ?? 0
        fetchKeyboardAnimationMetadata(notification)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        fetchKeyboardMetadata(notification)
        isShown = true
        notify { $0.keyboardWillShow?(self) }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        fetchKeyboardMetadata(notification)
        notify { $0.keyboardDidShow?(self) }
        UIWindow.mainWindow.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func tap(_ sender: UITapGestureRecognizer) {
        sender.view?.endEditing(true)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        fetchKeyboardAnimationMetadata(notification)
        notify { $0.keyboardWillHide?(self) }
    }
    
    func keyboardDidHide(_ notification: Notification) {
        height = 0
        animationDuration = 0
        animationCurve = .linear
        isShown = false
        notify { $0.keyboardDidHide?(self) }
        tapGestureRecognizer.view?.removeGestureRecognizer(tapGestureRecognizer)
    }
    
    func performAnimation( _ animation: Block) {
        UIView.beginAnimations(nil, context:nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        animation()
        UIView.commitAnimations()
    }
}

