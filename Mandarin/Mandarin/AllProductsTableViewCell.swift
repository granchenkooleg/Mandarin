//
//  AllProductsTableViewCell.swift
//  Mandarin
//
//  Created by Oleg on 11/23/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class AllProductsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thubnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thubnailImageView.layer.cornerRadius = 37
        thubnailImageView.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
