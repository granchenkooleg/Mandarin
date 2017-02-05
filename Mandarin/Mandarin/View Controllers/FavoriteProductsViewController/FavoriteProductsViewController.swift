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
    
    var internalProductsForListOfWeightVC = [Products]()
    var _productsList = [Products]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Resize cell
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Only isAuthorized user can see it VC
        guard  User.isAuthorized() else {
            UIAlertController.alert("Только зарегистрированный пользователь может добавлять в избранные".ls).show()
            return
        }
        internalProductsForListOfWeightVC = []
        _productsList = []
        guard let id = User.currentUser?.id else {return}
        let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                 "user_id" : Int(id)] as [String : Any]
        
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
                let units = json["units"].string ?? ""
                var image = Data()
                if icon.isEmpty == false, let imageData = try? Data(contentsOf: URL(string: icon) ?? URL(fileURLWithPath: "")){
                    image = imageData
                }
                
                let list = Products(id: id, description: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody, units: units, image: image)
                self?.internalProductsForListOfWeightVC.append(list)
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
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _productsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FavoriteProductsViewController"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FavoriteProductsTableViewCell
        
        let productDetails = _productsList[indexPath.row]
        Dispatch.mainQueue.async { _ in
            cell.thubnailImageView?.image = UIImage(data: productDetails.image)
        }
        
        cell.nameLabel?.text = productDetails.name
        cell.descriptionLabel?.text = productDetails.description
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

