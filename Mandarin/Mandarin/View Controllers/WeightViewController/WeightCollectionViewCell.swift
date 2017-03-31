//
//  WeightCollectionViewCell.swift
//  Bezpaketov
//
//  Created by Oleg on 12/7/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class WeightCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weightUnitsLabelOne: UILabel!
    @IBOutlet weak var iconWeightImageViev: UIImageView!
    var unitsProduct: String?
    
    
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? Color.Bezpaketov : UIColor.white
        }
    }
    
    
}
