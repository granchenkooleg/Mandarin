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
    
    var internalProductsForListOfWeightVC = [Products]()
    var _productsList = [Products]()
    
    @IBOutlet weak var overPlusAndMinusButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var name_2Label: UILabel!
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
    @IBOutlet weak var weightLabel: UILabel!
    
    // For favoriteProductOfUser
    //    var taskId: String?
    var weightDetailsVC: String?
    var categoryIdProductDetailsVC: String?
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
        
        internalProductsForListOfWeightVC = []
        _productsList = []
        if let id = User.currentUser?.idUser  {
        let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                 "user_id" : Int(id) as Any] as [String : Any]
        
        UserRequest.favorite(param as [String : AnyObject], completion: {[weak self] json in
            json.forEach { _, json in
                guard (json.isEmpty) == false else {return}
                let id = json["id"].string ?? ""
                let created_at = json["created_at"].string ?? ""
                let icon = json["icon"].string ?? ""
                let name = json["name"].string ?? ""
                let category_id = json["category_id"].string ?? ""
                let weight = json["weight"].string ?? ""
                let description = json["description"].string ?? ""
                let brand = json["brand"].string ?? ""
                let calories = json["calories"].string ?? ""
                let proteins = json["proteins"].string ?? ""
                let zhiry = json["zhiry"].string ?? ""
                let uglevody = json["uglevody"].string ?? ""
                let price = json["price"].string ?? ""
                let favorite = json["favorite"].string ?? ""
                let status = json["status"].string ?? ""
                let expire_date = json["expire_date"].string ?? ""
                let category_name = json["category_name"].string ?? ""
                let price_sale = json["price_sale"].string ?? ""
                let units = json["units"].string ?? ""
                var image = Data()
                if icon.isEmpty == false, let imageData = try? Data(contentsOf: URL(string: icon) ?? URL(fileURLWithPath: "")){
                    image = imageData
                }
                
                let list = Products(id: id, description: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody, units: units, image: image)
                self?.internalProductsForListOfWeightVC.append(list)
            }
            
            self?._productsList = (self?.internalProductsForListOfWeightVC)!
            
            for i in (self?._productsList ?? []) {
                if i.category_id == self?.categoryIdProductDetailsVC && i.id == self?.idProductDetailsVC  {
                    self?.heartButton.isSelected = true
                    
                }
                
            }
            
            })
    }
    
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
        
        
        weightLabel.text = weightDetailsVC
        nameLabel.text = nameHeaderTextDetailsVC
        name_2Label.text = nameLabel.text
        descriptionView.text = descriptionDetailsVC ?? ""
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
    func buttonHeart() {
        //!! This can be useful 1..
//        let realm = try! Realm()
//        if let product = realm.objects(Product.self).filter("id  == [c] %@", idProductDetailsVC).first {
        
//            heartButton.isSelected = product.favoriteProductOfUser
            //then @IBAction func heartButton establish .selected
            heartButton.setImage(UIImage(named: "HeartCleanBillWhite" ), for: .selected)
            //at first establish .normal
            heartButton.setImage(UIImage(named: "HeartWhiteNew" ), for: .normal)
//        }
    }
    
    // button for addition to section "💛Я люблю"
    @IBAction func heartButton(_ sender: UIButton) {
        
        //sender.loading = true
        
        if sender.isSelected == false {
            
            //adding to Favorite
            let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                     "product_id" : idProductDetailsVC,
                                     "user_id" : Int((User.currentUser?.idUser)!) ?? ""] as [String : Any]
            
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
                                     "user_id" : Int((User.currentUser?.idUser)!) ?? "",
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
        
        //!! This can be useful 2..
//        updateTask(!heartButton.isSelected)
        
    }
    
    //!! This can be useful 3..
//    // For favoriteProductOfUser
//    fileprivate func updateTask(_ checked: Bool) {
//        if let realm = try? Realm() {
//            //let id = self.taskId,
//            
//            if let product = realm.objects(Product.self).filter("id  == [c] %@", idProductDetailsVC).first {
//                try! realm.write {
//                    product.favoriteProductOfUser = checked
//                }
//                heartButton.isSelected = product.favoriteProductOfUser
//            }
//        }
//    }
    
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
        
        
        UIAlertController.alert("Товар добавлен в пакет.".ls).show()
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
