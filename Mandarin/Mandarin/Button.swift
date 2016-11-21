//
//  Button.swift
//  BinarySwipe
//
//  Created by Macostik on 5/23/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import Foundation
import UIKit

protocol Highlightable: class {
    var highlighted: Bool { get set }
}

protocol Selectable: class {
    var selected: Bool { get set }
}

extension UIControl: Highlightable, Selectable {}

extension UILabel: Highlightable, Selectable {
    var selected: Bool {
        get { return isHighlighted }
        set { isHighlighted = newValue }
    }
}

class Button : UIButton {
    
    convenience init(icon: String, font: UIFont = UIFont.binarySwipe(UIFont.systemFontSize), size: CGFloat = UIFont.systemFontSize, textColor: UIColor = UIColor.white) {
        self.init()
        titleLabel?.font = font
        setTitle(icon, for: UIControlState())
        setTitleColor(textColor, for: UIControlState())
    }
    
    static let minTouchSize: CGFloat = 44.0
    
    var animated: Bool = false
    var spinner: UIActivityIndicatorView?
    
    @IBOutlet var highlightings: [UIView] = []
    @IBOutlet var selectings: [UIView] = []
    
    @IBInspectable var insets: CGSize = CGSize.zero
    @IBInspectable var spinnerColor: UIColor?
    
    @IBInspectable lazy var normalColor: UIColor = self.backgroundColor ?? UIColor.clear
    @IBInspectable lazy var highlightedColor: UIColor = self.defaultHighlightedColor()
    @IBInspectable lazy var selectedColor: UIColor = self.backgroundColor ?? UIColor.clear
    @IBInspectable lazy var disabledColor: UIColor = self.backgroundColor ?? UIColor.clear
    
    @IBInspectable var localize: Bool = false {
        willSet {
            if newValue == true {
                setTitle(title(for: UIControlState())?.ls, for: UIControlState())
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
    
    @IBInspectable var touchArea: CGSize = CGSize(width: minTouchSize, height: minTouchSize)
    
    var loading: Bool = false {
        willSet {
            if loading != newValue {
                if newValue == true {
                    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
                    spinner.color = spinnerColor ?? titleColor(for: UIControlState())
                    var spinnerSuperView: UIView = self
                    let contentWidth = sizeThatFits(size).width
                    if (self.width - contentWidth) < spinner.width {
                        if let superView = self.superview {
                            spinnerSuperView = superView
                        }
                        spinner.center = center
                        alpha = 0
                    } else {
                        let size = bounds.size
                        spinner.center = CGPoint(x: size.width - size.height/2, y: size.height/2)
                    }
                    spinnerSuperView.addSubview(spinner)
                    spinner.startAnimating()
                    self.spinner = spinner
                    isUserInteractionEnabled = false
                } else {
                    if spinner?.superview != self {
                        alpha = 1
                    }
                    spinner?.removeFromSuperview()
                    isUserInteractionEnabled = true
                }
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            update()
            highlightings.all({ ($0 as? Highlightable)?.highlighted = isHighlighted })
        }
    }
    
    override var isSelected: Bool {
        didSet {
            update()
            selectings.all({ ($0 as? Selectable)?.selected = isSelected })
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            update()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        update()
    }
    
    func defaultHighlightedColor() -> UIColor {
        return self.backgroundColor ?? UIColor.clear
    }
    
    func update() {
        let normalColor = self.normalColor
        let selectedColor = self.selectedColor
        let highlightedColor = self.highlightedColor
        let disabledColor = self.disabledColor
        var backgroundColor: UIColor = disabledColor
        if isEnabled {
            if isHighlighted {
                backgroundColor = highlightedColor
            } else {
                backgroundColor = isSelected ? selectedColor : normalColor
            }
        }
        if !(backgroundColor.isEqual(self.backgroundColor)) {
            setBackgroundColor(backgroundColor, animated: animated)
        }
    }
    
    override var intrinsicContentSize : CGSize {
        let intrinsicSize = super.intrinsicContentSize
        return CGSize(width: intrinsicSize.width + insets.width, height: intrinsicSize.height + insets.height)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var rect = bounds
        rect = rect.insetBy(dx: -max(0, touchArea.width - rect.width)/2, dy: -max(0, touchArea.height - rect.height)/2)
        return rect.contains(point)
    }
    
    fileprivate var clickHelper: ObjectBlock? = nil
    
    func click(_ clickHelper: @escaping ObjectBlock) {
        self.addTarget(self, action: #selector(performAction), for: .touchUpInside)
        self.clickHelper = clickHelper
    }
    
    func performAction() {
        clickHelper?(self)
    }
}

class SegmentButton: Button {
    
    override var isHighlighted: Bool {
        set { }
        get {
            return super.isHighlighted
        }
    }
}

class PressButton: Button {
    
    override func defaultHighlightedColor() -> UIColor {
        return normalColor.withAlphaComponent(0.1) 
    }
}

extension UIFont {
    
    class func binarySwipe(_ size: CGFloat) -> UIFont! {
        return UIFont(name: "binarySwipe", size: size)
    }
}

