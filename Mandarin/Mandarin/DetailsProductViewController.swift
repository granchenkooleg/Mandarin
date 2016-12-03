//
//  DetailsViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/23/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class DetailsProductViewController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet  var productsImageView: UIImageView!
    var productsImage: String! // name our image
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productsImageView = UIImageView ()
        productsImageView.image = UIImage(named: productsImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
