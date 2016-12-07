//
//  CategoryViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/30/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class CategoryViewController: BaseViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var categoryId: String?
    var nameText: String?
    
    // @IBOutlet weak var tableView: UITableView!
    
    //    fileprivate var internalProducts: [Products] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = nameText
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        guard let categoryId = categoryId else { return }
        UserRequest.getAllProductsCategory(categoryID: categoryId, entryParams: param as [String : AnyObject], completion: {[weak self] json in
           print (">>self - \(self?.categoryId)<<")
            json.forEach { _, json in
                let id = json["id"].string ?? ""
                //let description = json["description"].string ?? ""
                //let proteins = json["proteins"].string ?? ""
                //let calories = json["calories"].string ?? ""
                //let zhiry = json["zhiry"].string ?? ""
                //let favorite = json["favorite"].string ?? ""
                //let category_id = json["category_id"].string ?? ""
               // let brand = json["brand"].string ?? ""
               // let price_sale = json["price_sale"].string ?? ""
                let weight = json["weight"].string ?? ""
               // let status = json["status"].string ?? ""
               // let expire_date = json["expire_date"].string ?? ""
               // let price = json["proteins"].string ?? ""
                let created_at = json["created_at"].string ?? ""
                let icon = json["icon"].string ?? ""
                //let category_name = json["category_name"].string ?? ""
                let name = json["name"].string ?? ""
                //let uglevody = json["uglevody"].string ?? ""
                let units = json["units"].string ?? ""
                
                let productCategory = Category (id: id, icon: icon, name: name, created_at: created_at, units: units, weight: weight)
                self?.internalProducts.append(productCategory)
            }
            self?._products = (self?.internalProducts)!
            self?.tableView.reloadData()
            })
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _products.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CategoryTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CategoryTableViewCell
        
        let productDetails = _products[indexPath.row]
        Dispatch.mainQueue.async { _ in
            let imageData: Data = try! Data(contentsOf: URL(string: productDetails.icon)!)
            cell.thubnailImageView?.image = UIImage(data: imageData)
        }
        
        cell.nameLabel?.text = productDetails.name
        
        return cell
    }
    
    //MARK: Segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weightViewController = Storyboard.Weight.instantiate()
        weightViewController.unitsProduct = _products[indexPath.row].units
        weightViewController.weightProduct = _products[indexPath.row].weight
        weightViewController.nameText = _products[indexPath.row].name
        UINavigationController.main.pushViewController(weightViewController, animated: true)
    }
        
        
}

