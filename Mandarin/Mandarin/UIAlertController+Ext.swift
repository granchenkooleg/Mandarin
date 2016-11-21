//
//  UIAlertController+.swift
//  BinarySwipe
//
//  Created by Yuriy on 5/31/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    class func alert(_ message: String?) -> UIAlertController {
        return UIAlertController(title: nil, message: message, preferredStyle: .alert)
    }
    
    class func alert(_ title: String?, message: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    class func actionSheet(_ title: String?, message: String? = nil) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    }
    
    func action(_ title: String?, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        addAction(action)
        return self
    }
    
    func show () {
        show(nil)
    }
    
    func show(_ sender: UIView?) {
        let navigation = UINavigationController.main
        guard let presentingViewController = navigation.presentedViewController ?? navigation.topViewController else { return }
        if actions.count == 0 {
            action("ok".ls)
        }
        if let popoverController = self.popoverPresentationController , self.preferredStyle == .actionSheet {
            if let sender = sender {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            } else {
                popoverController.sourceView = presentingViewController.view
                popoverController.sourceRect = CGRect(x: 0, y: navigation.view.frame.midY - 1, width: navigation.view.width, height: 1)
            }
            popoverController.permittedArrowDirections = .any
        }
        presentingViewController.present(self, animated: true, completion: nil)
    }
}
