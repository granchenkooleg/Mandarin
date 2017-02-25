//
//  HolderView.swift
//  Mandarin
//
//  Created by Oleg on 2/25/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import Foundation

class HolderView: UIView {
    
    let ovalLayer = OvalLayer()
    
    var parentFrame :CGRect = CGRect.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addOval() {
        layer.addSublayer(ovalLayer)
        ovalLayer.expand()
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(HolderView.wobbleOval),
                             userInfo: nil, repeats: false)
    }
    
    func wobbleOval() {
        ovalLayer.wobble()
    }
}

