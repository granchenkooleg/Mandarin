//
//  CategoryViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/30/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class CategoryViewControllerSegment: BaseViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    //from segue
    var nameHeaderText: String?
    
    // @IBOutlet weak var tableView: UITableView!
    
    //    fileprivate var internalProducts: [Products] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.separatorStyle = .none
        
        headerLabel?.text = nameHeaderText
        getAllCategory()
    }
    
    func getAllCategory () {
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
            guard let imageData: Data = try? Data(contentsOf: URL(string: productDetails.icon)!) else { return }
            cell.thubnailImageView?.image = UIImage(data: imageData)
        }
        
        cell.nameLabel?.text = productDetails.name
        
        return cell
    }
    
    //MARK: Segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getWeigth(indexPath: indexPath)
    }
    
    func getWeigth(indexPath: IndexPath) {
        let categoryViewController = Storyboard.Category.instantiate()
        categoryViewController.categoryId = _products[indexPath.row].id
        categoryViewController.nameHeaderText = _products[indexPath.row].name
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
        containerViewController.addController(categoryViewController)
    }
}

class CategoryViewController: CategoryViewControllerSegment {
    
    var categoryId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func getAllCategory() {
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        guard let categoryId = categoryId else { return }
        UserRequest.getAllProductsCategory(categoryID: categoryId, entryParams: param as [String : AnyObject], completion: {[weak self] json in
            //print (">>self - \(self?.categoryId)<<")
            json.forEach { _, json in
                let id = json["id"].string ?? ""
                let category_id = json["category_id"].string ?? ""
                let created_at = json["created_at"].string ?? ""
                let icon = json["icon"].string ?? ""
                
                let name = json["name"].string ?? ""
                
                let units = json["units"].string ?? ""
                
                let productCategory = Category (id: id, icon: icon, name: name, created_at: created_at, units: units, category_id: category_id)
                self?.internalProducts.append(productCategory)
            }
            self?._products = (self?.internalProducts)!
            self?.tableView.reloadData()
        })
    }
    
    //segue
    override func getWeigth(indexPath: IndexPath) {
        let weightViewController = Storyboard.Weight.instantiate()
        weightViewController.unitOfWeight = _products[indexPath.row].units
        weightViewController.nameWeightHeaderText = _products[indexPath.row].name
        weightViewController.podCategory_id = _products[indexPath.row].id
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
        containerViewController.addController(weightViewController)
    }
}

