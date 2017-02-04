//
//  DetailsViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/23/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import RealmSwift

class DetailsProductViewController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var overPlusAndMinusButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var uglevodyLabel: UILabel!
    @IBOutlet weak var zhiryLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var ccalLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var dateExpireLabel: UILabel!
    @IBOutlet weak var headerTextInDetailsVC: UILabel!
    @IBOutlet weak var productsImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    var priceSaleDetailsVC: String?
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
    var quantity: Int = 1
    //for cart
    //var quantityProducts: String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heartButton.isHidden = true
        
        //display iconHeart for Autorized user
        if User.isAuthorized()  {
            buttonHeart()
            heartButton.isHidden = false
        }
        
        //call overPlusAndMinusButton function for display
        determinantForOverPlusAndMinusButton()
        
        //quantityCartLabel.text = quantityProducts
        // Make a choice prices for to display prices
        if Double(priceSaleDetailsVC ?? "") ?? 0 > Double(0.00) {
            priceLabel?.text = String(priceSaleDetailsVC ?? "") + " грн."
        } else {
            priceLabel?.text = ((priceDetailsVC ?? "") + " грн.")
        }
        
        nameLabel.text = nameHeaderTextDetailsVC
        descriptionView.text = descriptionDetailsVC
        uglevodyLabel.text = uglevodyDetailsVC
        zhiryLabel.text = zhiryDetailsVC
        proteinLabel.text = proteinsDetailsVC
        ccalLabel.text = caloriesDetailsVC
        brandLabel.text = brandDetailsVC
        dateExpireLabel.text = expire_dateDetailsVC
        headerTextInDetailsVC.text = nameHeaderTextDetailsVC
        guard let imageData = try? Data.init(contentsOf: URL.init(string: iconDetailsVC ?? "") ?? URL(fileURLWithPath: "")) else {return}
        productsImageView.image = UIImage(data: imageData)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quantity = 1
        quantityLabel.text = "\(quantity) шт."
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
                                     "user_id" : Int((User.currentUser?.id)!)] as [String : Any]
            
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
                                     "user_id" : Int((User.currentUser?.id)!),
                                     "remove" : "1"] as [String : Any]
            
            UserRequest.addToFavorite(param as [String : AnyObject], completion: {/*[weak self]*/ success in
                if success == true {
                    UIAlertController.alert("Товар удален из любимых!".ls).show()
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
    
    @IBAction func addProduct(sender: AnyObject) {
        quantity += 1
        quantityLabel.text = "\(quantity) шт."
    }
    
    @IBAction func subProduct(sender: AnyObject) {
        guard quantity > 1 else { return }
        quantity -= 1
        quantityLabel.text = "\(quantity) шт."
    }
    
    //button cart
    @IBAction func createCart(_ sender: AnyObject) {
        
        if overPlusAndMinusButton.isHidden == false {
         overPlusAndMinusButton.isHidden = true
            return
        } else {
            overPlusAndMinusButton.isHidden = false
        }
        
        //        let list = ProductsForRealm.setupProduct(id: id, descriptiqonForProduct: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_salquglevody, units: "")
        //        self?.internalProducts.append(list)
        //        let products = ProductsForRealm(value: list)
        //        User.currentUser?.products.append(products)
        
        
        UIAlertController.alert("Товар добавлен в корзину.".ls).show()
        updateProduct()
        updateProductInfo()
        
        if quantity > 1 {
            quantity = 1
        }
        quantityLabel.text = "\(quantity) шт."
        //        navigationController!.popViewController(animated: true)
        
        // quantityProducts  = "2"
    }
    
    func updateProduct () {
        let realm = try! Realm()
        if let product = realm.objects(ProductsForRealm.self).filter("id  == [c] %@", idProductDetailsVC).first {
            try! realm.write {
                product.quantity = "\((Int(product.quantity) ?? 0) + quantity)"
            }
        } else {
            var image: Data? = nil
            if iconDetailsVC.isEmpty == false, let imageData = try? Data(contentsOf: URL(string: iconDetailsVC) ?? URL(fileURLWithPath: "")){
                image = imageData
            }
            let _ = ProductsForRealm.setupProduct(id: idProductDetailsVC ?? "", descriptionForProduct: descriptionDetailsVC ?? "", proteins: proteinsDetailsVC ?? "", calories: caloriesDetailsVC ?? "", zhiry: zhiryDetailsVC ?? "", favorite: "", category_id: "", brand: brandDetailsVC ?? "", price_sale: priceSaleDetailsVC ?? "", weight: "", status: "", expire_date: expire_dateDetailsVC ?? "", price: priceDetailsVC ?? "", created_at: created_atDetailsVC ?? "", icon: iconDetailsVC ?? "", category_name: "", name: nameHeaderTextDetailsVC ?? "" , uglevody: uglevodyDetailsVC ?? "" , units: "", quantity: "\(quantity)", image: image)
        }
    }
}
