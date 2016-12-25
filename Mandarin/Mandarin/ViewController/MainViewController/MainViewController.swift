//
//  MainViewController.swift
//  Mandarin
//
//  Created by Yuriy on 11/29/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, SegmentedControlDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var segmentControl: SegmentControl?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentControl?.delegate = self
        segmentControl?.layer.cornerRadius = 5.0
        segmentControl?.layer.borderColor = Color.mandarin.cgColor
        segmentControl?.layer.borderWidth = 1.0
        segmentControl?.layer.masksToBounds = true
        segmentControl?.selectedSegment = 0
        self.segmentedControl(self.segmentControl!, didSelectSegment: 0)
    }
    
    //MARK: SegmentedControlDelegate
    
    func segmentedControl(_ control: SegmentControl, didSelectSegment segment: Int) {
        self.internalProducts = []
        if segment == 0 {
            let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
            UserRequest.getAllCategories(param as [String : AnyObject], completion: {[weak self] json in
                json.forEach { _, json in
                    print (">>self - \(json["name"])<<")
                    let id = json["id"].string ?? ""
                    let created_at = json["created_at"].string ?? ""
                    let icon = json["icon"].string ?? ""
                    let name = json["name"].string ?? ""
                    let units = json["units"].string ?? ""
                    let category_id = json["category_id"].string ?? ""
                    
                    let category = Category(id: id, icon: icon, name: name, created_at: created_at, units: units, category_id: category_id)
                    self?.internalProducts.append(category)
                }
                self?._products = (self?.internalProducts)!
                self?.tableView.reloadData()
            })
            
        } else if segment == 1 {
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
                    
                    let list = Product(id: id, description: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody, units: "")
                    self?.internalProducts.append(list)
                    let products = ProductsForRealm.setupProduct(id: id, descriptionForProduct: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody, units: "")
                    let realm = try! Realm()
                    try! realm.write {
                       User.currentUser?.products.append(products)
                    }
                }
                self?._products = (self?.internalProducts)!
                self?.tableView.reloadData()
            })
        } else {self.tableView.reloadData()}
       
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _products.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MainTableViewCell
        
        let productDetails = _products[(indexPath as NSIndexPath).row]
        Dispatch.mainQueue.async { _ in
            let imageData: Data = try! Data(contentsOf: URL(string: productDetails.icon)!)
            cell.thubnailImageView?.image = UIImage(data: imageData)
        }
        
        cell.nameLabel?.text = productDetails.name
        
        return cell
    }
    
    //MARK: Segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryViewController = Storyboard.Category.instantiate()
        categoryViewController.categoryId = _products[indexPath.row].id
        categoryViewController.nameHeaderText = _products[indexPath.row].name
        UINavigationController.main.pushViewController(categoryViewController, animated: true)
    }
    
    override func searchTextChanged(sender: UITextField) {
        super.searchTextChanged(sender: sender)
        tableView.reloadData()
    }
    
    
}
