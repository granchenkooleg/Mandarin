//
//  SegmentControl.swift
//  BinarySwipe
//
//  Created by Macostik on 5/23/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import Foundation
import UIKit

@objc protocol SegmentedControlDelegate {
    @objc optional func segmentedControl(_ control: SegmentedControl, didSelectSegment segment: Int)
    @objc optional func segmentedControl(_ control: SegmentedControl, shouldSelectSegment segment: Int) -> Bool
}

final class SegmentedControl: UIControl {
    
    @IBInspectable var showHighlightLine: Bool = false
    @IBInspectable var setSelectedDefault: Int = 0 {
        willSet { setSelectedControl(controlForSegment(newValue)) }
    }
    
    fileprivate lazy var controls: [UIControl] = self.subviews.reduce([UIControl](), {
        if let control = $1 as? UIControl {
            return $0 + [control]
        } else {
            return $0
        }
    })
    
    override func awakeFromNib() {
        super.awakeFromNib()
        controls.all({ $0.addTarget(self, action: #selector(self.selectSegmentTap(_:)), for: .touchUpInside) })
    }
    
    var selectedSegment: Int {
        get { return controls.index(where: { $0.isSelected }) ?? NSNotFound }
        set { setSelectedControl(controlForSegment(newValue)) }
    }
    
    @IBOutlet weak var delegate: SegmentedControlDelegate?
    
    func deselect() {
        selectedSegment = NSNotFound
    }
    
    func selectSegmentTap(_ sender: UIControl) {
        if let index = controls.index(of: sender) , !sender.isSelected {
            
            guard (delegate?.segmentedControl?(self, shouldSelectSegment:index) ?? true) else { return }
            
            setSelectedControl(sender)
            delegate?.segmentedControl?(self, didSelectSegment:index)
            sendActions(for: .valueChanged)
            setNeedsDisplay()
        }
    }
    
    fileprivate func setSelectedControl(_ control: UIControl?) {
        controls.all({ $0.isSelected = $0 == control })
    }
    
    func controlForSegment(_ segment: Int) -> UIControl? {
        return controls[safe: segment]
    }
    
    override func draw(_ rect: CGRect) {
        if showHighlightLine == true {
            guard let selectedControl = controlForSegment(selectedSegment == NSNotFound ? 0 : selectedSegment) else { return }
            let path = UIBezierPath()
            path.move(selectedControl.x ^ height).line(40 + selectedControl.x ^ height)
            UIColor.white.setStroke()
            path.lineWidth = 10.0 / max(2, UIScreen.main.scale)
            path.stroke()
        }
    }
}

