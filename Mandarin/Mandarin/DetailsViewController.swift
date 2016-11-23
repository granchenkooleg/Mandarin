//
//  DetailsViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/23/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class DetailsViewController: BaseViewController {
    
    @IBOutlet  var friendsImageView: UIImageView!
    var friendsImage: String! // name our image
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsImageView = UIImageView ()
        friendsImageView.image = UIImage(named: friendsImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
