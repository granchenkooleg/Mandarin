//
//  DetailsViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/23/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class DetailsProductViewController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var uglevodyLabel: UILabel!
    @IBOutlet weak var zhiryLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var ccalLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var dateExpireLabel: UILabel!
    @IBOutlet weak var headerTextInDetailsVC: UILabel!
    @IBOutlet weak var productsImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    var productsImage: String! // name our image
    var nameHeaderTextDetailsVC: String?
    var created_atDetailsVC: String?
    var iconDetailsVC: String!
    var expire_dateDetailsVC: String?
    var brandDetailsVC: String?
    var caloriesDetailsVC: String?
    var proteinsDetailsVC: String?
    var zhiryDetailsVC: String?
    var uglevodyDetailsVC: String?
    var descriptionDetailsVC: String?
    var priceDetailsVC: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceLabel.text = priceDetailsVC! + " грн."
        nameLabel.text = nameHeaderTextDetailsVC
        descriptionTextField.text = descriptionDetailsVC
        uglevodyLabel.text = uglevodyDetailsVC
        zhiryLabel.text = zhiryDetailsVC
        proteinLabel.text = proteinsDetailsVC
        ccalLabel.text = caloriesDetailsVC
        brandLabel.text = brandDetailsVC
        dateExpireLabel.text = expire_dateDetailsVC
        headerTextInDetailsVC.text = nameHeaderTextDetailsVC
        guard let imageData = try? Data.init(contentsOf: URL.init(string: iconDetailsVC)!) else {return}
        productsImageView.image = UIImage(data: imageData)
    }
    
}
