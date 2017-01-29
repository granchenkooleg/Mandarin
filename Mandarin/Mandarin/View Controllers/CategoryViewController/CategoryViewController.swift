//
//  CategoryViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/30/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class CategoryViewControllerSegment: BaseViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerLabel: UILabel?
    @IBOutlet weak var tableView: UITableView?
    var spiner = UIActivityIndicatorView()
    //from segue
    var nameHeaderText: String?
    
    // @IBOutlet weak var tableView: UITableView!
    
    internal var categoryContainer = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.separatorStyle = .none
        spiner.hidesWhenStopped = true
        spiner.activityIndicatorViewStyle = .gray
        view.add(spiner)
        spiner.center.x = view.center.x
        spiner.center.y = view.center.y - 150
        spiner.startAnimating()
        
        headerLabel?.text = nameHeaderText
        let favoriteProducts = Category().allCategories()
        guard favoriteProducts.count != 0 else {
            getAllCategory { [weak self] _ in
                self?.categoryContainer = Category().allCategories()
                self?.spiner.stopAnimating()
                self?.tableView?.reloadData()
            }
            
            return
        }
        categoryContainer = favoriteProducts
        spiner.stopAnimating()
        tableView?.reloadData()
    }
    
    func getAllCategory (_ completion: @escaping Block) {
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        UserRequest.getAllCategories(param as [String : AnyObject], completion: { json in
            json.forEach { _, json in
                let id = json["id"].string ?? ""
                let created_at = json["created_at"].string ?? ""
                let icon = json["icon"].string ?? ""
                let name = json["name"].string ?? ""
                let units = json["units"].string ?? ""
                let category_id = json["category_id"].string ?? ""
                var image: Data? = nil
                if icon.isEmpty == false, let imageData = try? Data(contentsOf: URL(string: icon) ?? URL(fileURLWithPath: "")){
                    image = imageData
                }
                
                Category.setupCategory(id: id, icon: icon, name: name, created_at: created_at, units: units, category_id: category_id, image: image)
            }
            completion()
        })
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryContainer.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CategoryTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CategoryTableViewCell
        
        let category = categoryContainer[indexPath.row]
        Dispatch.mainQueue.async { _ in
            cell.thubnailImageView?.image = UIImage(data: category.image ?? Data())
            cell.nameLabel?.text = category.name
        }
        
        return cell
    }
    
    //MARK: Segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getWeigth(indexPath: indexPath)
    }
    
    func getWeigth(indexPath: IndexPath) {
        let categoryViewController = Storyboard.Category.instantiate()
        categoryViewController.categoryId = categoryContainer[indexPath.row].id
        categoryViewController.nameHeaderText = categoryContainer[indexPath.row].name
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
        containerViewController.addController(categoryViewController)
    }
}

class CategoryViewController: CategoryViewControllerSegment {
    
    var categoryId: String?
     internal var categories = [Category]()
    
    override func viewDidLoad() {
        tableView?.separatorStyle = .none
        headerLabel?.text = nameHeaderText
        getAllCategory({})
    }
    
    override func getAllCategory(_ completion: @escaping Block) {
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        guard let categoryId = categoryId else { return }
        UserRequest.getAllProductsCategory(categoryID: categoryId, entryParams: param as [String : AnyObject], completion: {[weak self] json in
            guard let weakSelf = self else { return }
            json.forEach { _, json in
                let id = json["id"].string ?? ""
                let category_id = json["category_id"].string ?? ""
                let created_at = json["created_at"].string ?? ""
                let icon = json["icon"].string ?? ""
                
                let name = json["name"].string ?? ""
                
                let units = json["units"].string ?? ""
                
                var image: Data? = nil
                if icon.isEmpty == false, let imageData = try? Data(contentsOf: URL(string: icon) ?? URL(fileURLWithPath: "")){
                    image = imageData
                }
                let category = Category.setupCategory(id: id, icon: icon, name: name, created_at: created_at, units: units, category_id: category_id, image: image)
                self?.categories.append(category)
            }
            weakSelf.categoryContainer = weakSelf.categories
            weakSelf.tableView?.reloadData()
        })
    }
    
    //segue
    override func getWeigth(indexPath: IndexPath) {
        let weightViewController = Storyboard.Weight.instantiate()
        weightViewController.unitOfWeight = categoryContainer[indexPath.row].units
        weightViewController.nameWeightHeaderText = categoryContainer[indexPath.row].name
        weightViewController.podCategory_id = categoryContainer[indexPath.row].id
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
        containerViewController.addController(weightViewController)
    }
}

