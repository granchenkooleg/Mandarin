//
//  ListOfProductsByWeightViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/30/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class ListOfProductsByWeightViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listHeaderLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var nameListsOfProductsHeaderText: String?
    //property for compare with allListProducts
    var weightOfWeightVC: String?
    var idPodcategory: String?
    
    var internalProductsForListOfWeightVC = [Product]()
    var _productsList = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listHeaderLabel.text = nameListsOfProductsHeaderText
        
        // Do any additional setup after loading the view.
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        UserRequest.listAllProducts(param as [String : AnyObject], completion: {[weak self] json in
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
                
                
                /*!
                 *  Here we doing compare
                 *                              if idPodcategory == category_id && weightOfWeightVC == weightListOfProducts {
                 *  let category = Category(id: id, icon: icon, name: name, created_at: created_at, category_id: category_id /*,weight: weight*/)
                 *  self?.internalProducts.append(category)
                 *  } else { return }
                 *
                 */
                
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
        let cellIdentifier = "ListOfProductsByWeightViewController"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ListOfProductsByWeightTableViewCell
        
        let productDetails = _productsList[indexPath.row]
        Dispatch.mainQueue.async { _ in
            let imageData: Data = try! Data(contentsOf: URL(string: productDetails.icon)!)
            cell.thubnailImageView?.image = UIImage(data: imageData)
        }
        
        cell.nameLabel?.text = productDetails.name
        
        return cell
    }
    
    //    override func searchTextChanged(sender: UITextField) {
    //        if let text = sender.text {
    //            if text.isEmpty {
    //                _products = internalProducts;
    //            } else {
    //                _products =  self.internalProducts.filter { $0.name.lowercased().range(of: text, options: .caseInsensitive, range: nil, locale: nil) != nil }
    //            }
    //        }
    //        tableView.reloadData()
    //    }
    
    // MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsProductVC = Storyboard.DetailsProduct.instantiate()
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
}
