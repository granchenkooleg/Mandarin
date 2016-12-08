//
//  DetailsViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/23/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class DetailsProductViewController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var headerTextInDetailsVC: UILabel!
    @IBOutlet weak var productsImageView: UIImageView!
    var productsImage: String! // name our image
    var nameHeaderTextDetailsVC: String?
    var created_atDetailsVC: String?
    var iconDetailsVC: String!
     
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerTextInDetailsVC.text = nameHeaderTextDetailsVC
        
//        productsImageView = UIImageView ()
//        productsImageView.image = UIImage(named: iconDetailsVC)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
