//
//  Label.swift
//  BinarySwipe
//
//  Created by Macostik on 5/23/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import Foundation
import UIKit

class Label: UILabel {
    
    convenience init(icon: String, size: CGFloat = UIFont.systemFontSize, textColor: UIColor = UIColor.white) {
        self.init()
        font = UIFont.bezpaketov(size)
        text = icon
        self.textColor = textColor
    }

    @IBInspectable var localize: Bool = false {
        willSet {
            if newValue {
                text = text?.ls
                layoutIfNeeded()
            }
        }
    }
    
    @IBInspectable var rotate: Bool = false {
        willSet {
            if newValue == true {
                switch contentMode {
                case .bottom:
                    transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                case .left:
                    transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
                case .right:
                    transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
                default:
                    transform = CGAffineTransform.identity
                }
            }
        }
    }
}
