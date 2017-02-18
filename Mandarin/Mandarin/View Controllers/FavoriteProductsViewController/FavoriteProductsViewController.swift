//
//  FavoriteProductsViewController.swift
//  Mandarin
//
//  Created by Yuriy on 1/3/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteProductsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var internalProductsForListOfWeightVC = [Products]()
    var _productsList = [Products]()
    var basketHandler: Block? = nil
    
    var label: UILabel? = nil
    
    var quantity: Int = 1
    
   // var productInstant: Results<Product>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Resize cell
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _productsList = []
        tableView.reloadData()
        
        // Only isAuthorized user can see it VC
        guard  User.isAuthorized() else {
            label = UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 100))
            label?.text = "Только зарегистрированный пользователь может добавлять в избранные."
            label?.lineBreakMode = .byWordWrapping
            label?.numberOfLines = 0
            label?.center = CGPoint(x: CGFloat(view.frame.size.width / 2), y: CGFloat(150))
            label?.textAlignment = .center
            self.view.addSubview(label!)
            return
        }
        internalProductsForListOfWeightVC = []
        _productsList = []
        guard let id = User.currentUser?.idUser else {return}
        let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                 "user_id" : Int(id) as! AnyHashable] as [String : Any]
        
        UserRequest.favorite(param as [String : AnyObject], completion: {[weak self] json in
            json.forEach { _, json in
                print (">>self - \(json["name"])<<")
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
                    let list = Products(id: id, description: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody, units: units, image: image)
                    self?.internalProductsForListOfWeightVC.append(list)
                }
            }
            
            self?._productsList = (self?.internalProductsForListOfWeightVC)!
            self?.tableView.reloadData()
            })
    }
    
    // For dynamic height cell
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        label?.removeFromSuperview()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _productsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FavoriteProductsViewController"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FavoriteProductsTableViewCell
        
        let productDetails = _productsList[indexPath.row]
        
        cell.buttonAction = {[weak self] (sender) in
            // Do whatever you want from your button here.
            
            let realm = try! Realm()
            if let product = realm.objects(ProductsForRealm.self).filter("id  == [c] %@", productDetails.id ).first {
                try! realm.write {
                    product.quantity = "\((Int((product.quantity)) ?? 0) + 1)"
                }
            } else {
                var image: Data? = nil
                if productDetails.icon.isEmpty == false, let imageData = try? Data(contentsOf: URL(string: productDetails.icon) ?? URL(fileURLWithPath: "")){
                    image = imageData
                }
                let _ = ProductsForRealm.setupProduct(id: productDetails.id , descriptionForProduct: productDetails.description , proteins: productDetails.proteins , calories: productDetails.calories , zhiry: productDetails.zhiry , favorite: "", category_id: "", brand: productDetails.brand , price_sale: productDetails.price_sale , weight: "", status: "", expire_date: productDetails.expire_date , price: productDetails.price , created_at: productDetails.created_at , icon: productDetails.icon , category_name: "", name: productDetails.name , uglevody: productDetails.uglevody , units: "", quantity: "\(self?.quantity)", image: image)
            }
            
            UIAlertController.alert("Товар добавлен в пакет.".ls).show()
            self?.basketHandler?()
        }
        
        Dispatch.mainQueue.async { _ in
            cell.thubnailImageView?.image = UIImage(data: productDetails.image)
        }
        
        cell.nameLabel?.text = productDetails.name
        cell.descriptionLabel?.text = productDetails.description
        cell.weightLabel?.text = productDetails.weight  + " \(_productsList[indexPath.row].units)"
        cell.priceOldLabel?.text = productDetails.price + " грн."
        
        //if price_sale != 0.00 грн, set it
        if productDetails.price_sale != "0.00" {
            cell.priceSaleLabel?.text = productDetails.price_sale +  "  грн."
            
            // create attributed string for strikethroughStyleAttributeName
            let myString = productDetails.price + " грн."
            let myAttribute = [ NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue ]
            let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
            
            // set attributed text on a UILabel
            cell.priceOldLabel?.attributedText = myAttrString
        } else {
            cell.priceSaleLabel?.text = ""
        }
        
        return cell
    }
    
    // MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailsVC (indexPath: indexPath)
    }
    
    func detailsVC (indexPath: IndexPath) {
        let detailsProductVC = Storyboard.DetailsProduct.instantiate()
        detailsProductVC.weightDetailsVC = _productsList[indexPath.row].weight + " \(_productsList[indexPath.row].units)"
        detailsProductVC.categoryIdProductDetailsVC = _productsList[indexPath.row].category_id
        detailsProductVC.priceSaleDetailsVC = _productsList[indexPath.row].price_sale
        detailsProductVC.idProductDetailsVC = _productsList[indexPath.row].id
        detailsProductVC.priceDetailsVC = _productsList[indexPath.row].price
        detailsProductVC.descriptionDetailsVC = _productsList[indexPath.row].description
        detailsProductVC.uglevodyDetailsVC = _productsList[indexPath.row].uglevody
        detailsProductVC.zhiryDetailsVC = _productsList[indexPath.row].zhiry
        
        detailsProductVC.proteinsDetailsVC = _productsList[indexPath.row].proteins
        detailsProductVC.caloriesDetailsVC = _productsList[indexPath.row].calories
        detailsProductVC.expire_dateDetailsVC = _productsList[indexPath.row].expire_date
        detailsProductVC.brandDetailsVC = _productsList[indexPath.row].brand
        detailsProductVC.iconDetailsVC = _productsList[indexPath.row].icon
        //detailsProductVC.DetailsVC = _products[indexPath.row].
        detailsProductVC.created_atDetailsVC = _productsList[indexPath.row].created_at
        detailsProductVC.nameHeaderTextDetailsVC = _productsList[indexPath.row].name
        UINavigationController.main.pushViewController(detailsProductVC, animated: true)
    }
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 0
    //    }
    //
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return 0
    //
    //    }
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        //        let cellIdentifier = "CategoryTableViewCell"
    //        //        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CategoryTableViewCell
    //        //
    //        //        let productDetails = _products[indexPath.row]
    //        //        Dispatch.mainQueue.async { _ in
    //        //            guard let imageData: Data = try? Data(contentsOf: URL(string: productDetails.icon)!) else { return }
    //        //            cell.thubnailImageView?.image = UIImage(data: imageData)
    //        //        }
    //        //
    //        //        cell.nameLabel?.text = productDetails.name
    //        //
    //        return UITableViewCell()
    //    }
    
}

class FavoriteProductsTableViewCell: UITableViewCell {
    
    @IBOutlet var buttonCart: UIButton!
    
    var buttonAction: ((_ sender: AnyObject) -> Void)?
    
    @IBAction func buttonPressedCart(_ sender: Any) {
        self.buttonAction?(sender as AnyObject)
    }
    
    @IBOutlet weak var thubnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var priceOldLabel: UILabel!
    @IBOutlet weak var priceSaleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

