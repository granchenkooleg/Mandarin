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
    
    var favoriteProductsArray = [FavoriteProduct]()
    var productsList = [FavoriteProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        let favoriteProducts = FavoriteProduct.allProducts
        guard favoriteProducts.count != 0 else {
            getFavoriteProducts()
            return
        }
        productsList = favoriteProducts
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsList.count
    }
    
    func getFavoriteProducts() {
        let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                 "user_id" : User.isAuthorized()] as [String : Any]
        UserRequest.favorite(param as [String : AnyObject], completion: {[weak self] json in
            guard let weakSelf = self else { return }
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
                let units = json["units"].string ?? ""
                
                var image: Data? = nil
                if icon.isEmpty == false, let imageData = try? Data(contentsOf: URL(string: icon) ?? URL(fileURLWithPath: "")){
                    image = imageData
                }
                let list = FavoriteProduct.setupProduct(id: id, description_: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody, units: units, image: image)
                weakSelf.favoriteProductsArray.append(list)
            }
            
            weakSelf.productsList = weakSelf.favoriteProductsArray
            weakSelf.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FavoriteProductsViewController"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FavoriteProductsTableViewCell
        
        let productDetails = productsList[indexPath.row]
        Dispatch.mainQueue.async { _ in
         
            cell.thubnailImageView?.image = UIImage(data: productDetails.image ?? Data())
            
            cell.nameLabel?.text = productDetails.name
            cell.descriptionLabel?.text = productDetails.description_
            cell.weightLabel?.text = productDetails.weight  + " " + productDetails.units
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
            }
        }
        
        return cell
    }
    
    // MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailsVC (indexPath: indexPath)
    }
    
    func detailsVC (indexPath: IndexPath) {
        let detailsProductVC = Storyboard.DetailsProduct.instantiate()
        detailsProductVC.idProductDetailsVC = productsList[indexPath.row].id
        detailsProductVC.priceDetailsVC = productsList[indexPath.row].price
        detailsProductVC.descriptionDetailsVC = productsList[indexPath.row].description
        detailsProductVC.uglevodyDetailsVC = productsList[indexPath.row].uglevody
        detailsProductVC.zhiryDetailsVC = productsList[indexPath.row].zhiry
        detailsProductVC.proteinsDetailsVC = productsList[indexPath.row].proteins
        detailsProductVC.caloriesDetailsVC = productsList[indexPath.row].calories
        detailsProductVC.expire_dateDetailsVC = productsList[indexPath.row].expire_date
        detailsProductVC.brandDetailsVC = productsList[indexPath.row].brand
        detailsProductVC.iconDetailsVC = productsList[indexPath.row].icon
        //detailsProductVC.DetailsVC = _products[indexPath.row].
        detailsProductVC.created_atDetailsVC = productsList[indexPath.row].created_at
        detailsProductVC.nameHeaderTextDetailsVC = productsList[indexPath.row].name
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
        containerViewController.addController(detailsProductVC)
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

