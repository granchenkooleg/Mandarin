//
//  CategoryViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/30/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class CategoryViewController: BaseViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var categoryId: String?
    
    // @IBOutlet weak var tableView: UITableView!
    
    //    fileprivate var internalProducts: [Products] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79", "category_id" : "6"]
        UserRequest.getAllProducts(param as [String : AnyObject], completion: {[weak self] json in
           print (">>self - \(self?.categoryId)<<")
            json.forEach { _, json in
                let id = json["id"].string ?? ""
                let description = json["description"].string ?? ""
                let proteins = json["proteins"].string ?? ""
                let calories = json["calories"].string ?? ""
                let zhiry = json["zhiry"].string ?? ""
                let favorite = json["favorite"].string ?? ""
                let category_id = json["category_id"].string ?? ""
                let brand = json["brand"].string ?? ""
                let price_sale = json["price_sale"].string ?? ""
                let weight = json["weight"].string ?? ""
                let status = json["status"].string ?? ""
                let expire_date = json["expire_date"].string ?? ""
                let price = json["proteins"].string ?? ""
                let created_at = json["created_at"].string ?? ""
                let icon = json["icon"].string ?? ""
                let category_name = json["category_name"].string ?? ""
                let name = json["name"].string ?? ""
                let uglevody = json["uglevody"].string ?? ""
                
                let product = Product(id: id, description: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody)
                self?.internalProducts.append(product)
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
    
        
}

