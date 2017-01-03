//
//  DetailsViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/23/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class DetailsProductViewController: BaseViewController, UITableViewDelegate {
    
    
    
    @IBOutlet weak var overPlusAndMinusButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
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
    var idProductDetailsVC: String!
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
        
        //display iconHeart for Autorized user
        if User.isAuthorized()  {
            buttonHeart()
        }
        
        //call overPlusAndMinusButton function for display
        determinantForOverPlusAndMinusButton()
        
        
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
    
    //setting overPlusAndMinusButton
    func determinantForOverPlusAndMinusButton() -> Void {
        overPlusAndMinusButton.setBackgroundColor(Color.mandarin, animated: true)
        overPlusAndMinusButton.setTitle("В корзину", for: UIControlState.normal)
        overPlusAndMinusButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
    }
    
    //setting heartButton
    func buttonHeart() -> Void {
        //then @IBAction func heartButton establish .selected
        heartButton.setImage(UIImage(named: "HeartCleanBillWhite" ), for: .selected)
        //at first establish .normal
        heartButton.setImage(UIImage(named: "HeartWhiteNew" ), for: .normal)
        
    }
    
    // button for addition to section "💛Я люблю"
    @IBAction func heartButton(_ sender: UIButton) {
        
        //sender.loading = true
        
        if sender.isSelected == false {
            
            //adding to Favorite
            let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                     "product_id" : idProductDetailsVC,
                                     "user_id" : User.isAuthorized()] as [String : Any]
            
            UserRequest.addToFavorite(param as [String : AnyObject], completion: {/*[weak self]*/ success in
                if success == true {
                    UIAlertController.alert("Товар добавлен в \"Любимые\"!".ls).show()
                }
                //sender.loading = false
            })
            
            //it for fill heart white color. Look func buttonHeart(). [start
            sender.isSelected = !sender.isSelected
            // end
            ///////////////////////////////////////////////////////////////////////////
        } else {
            
            //remove from Favorite
            let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                     "product_id" : idProductDetailsVC,
                                     "user_id" : User.isAuthorized(),
                                     "remove" : "1"] as [String : Any]
            
            UserRequest.addToFavorite(param as [String : AnyObject], completion: {/*[weak self]*/ success in
                if success == true {
                    UIAlertController.alert("Товар удален из любимых!.".ls).show()
                }
                //sender.loading = false
            })
            
            //it for fill heart white color. Look func buttonHeart(). [start
            sender.isSelected = !sender.isSelected
            // end]
        }
    }
    
    //hidden overButton
    @IBAction func overButtonHidden(_ sender: UIButton) {
        overPlusAndMinusButton.isHidden = true
    }
    
    
}
