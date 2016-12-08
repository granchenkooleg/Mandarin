//
//  WeightCollectionViewCell.swift
//  Mandarin
//
//  Created by Oleg on 12/7/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class WeightCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weightUnitsLabelOne: UILabel!
    var unitsProduct: String?
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? Color.mandarin : UIColor.white
        }
    }
    
    
}
