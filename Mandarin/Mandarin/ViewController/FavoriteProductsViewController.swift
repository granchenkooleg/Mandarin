//
//  FavoriteProductsViewController.swift
//  Mandarin
//
//  Created by Yuriy on 1/3/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import UIKit

class FavoriteProductsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var internalProductsForListOfWeightVC = [Product]()
    var _productsList = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                 "user_id" : User.isAuthorized()] as [String : Any]
        
        UserRequest.favorite(param as [String : AnyObject], completion: {[weak self] json in
            json.forEach { _, json in
                print (">>self - \(json["name"])<<")
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
                
                
                let list = Product(id: id, description: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody, units: "")
                self?.internalProductsForListOfWeightVC.append(list)
            }
            
            self?._productsList = (self?.internalProductsForListOfWeightVC)!
            self?.tableView.reloadData()
            })
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _productsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FavoriteProductsViewController"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FavoriteProductsTableViewCell
        
        let productDetails = _productsList[indexPath.row]
        Dispatch.mainQueue.async { _ in
            let imageData: Data = try! Data(contentsOf: URL(string: productDetails.icon)!)
            cell.thubnailImageView?.image = UIImage(data: imageData)
        }
        
        cell.nameLabel?.text = productDetails.name
        cell.descriptionLabel?.text = productDetails.description
        //cell.weightLabel?.text = productDetails.weight + " " + (unitOfWeightForListOfProductsByWeightVC ?? "")
        cell.priceOldLabel?.text = productDetails.price + " грн."
        
        //if price_sale != 0.00 грн, set it
        guard productDetails.price_sale != "0.00" else {
            return cell
        }
        cell.priceSaleLabel?.text = productDetails.price_sale +  "  грн."
        
        // create attributed string for strikethroughStyleAttributeName
        let myString = productDetails.price + " грн."
        let myAttribute = [ NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue ]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        
        // set attributed text on a UILabel
        cell.priceOldLabel?.attributedText = myAttrString
        return cell
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

