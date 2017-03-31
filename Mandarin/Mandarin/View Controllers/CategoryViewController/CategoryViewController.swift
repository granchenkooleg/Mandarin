//
//  CategoryViewController.swift
//  Bezpaketov
//
//  Created by Oleg on 11/30/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import SDWebImage

class CategoryViewControllerSegment: BaseViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerLabel: UILabel?
    @IBOutlet weak var tableView: UITableView?
    
    //From segue
    var nameHeaderText: String?
    
    internal var categoryContainer = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // From ContainerVC if Internet connection
        NotificationCenter.default.addObserver(self, selector: #selector(CategoryViewControllerSegment.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        tableView?.separatorStyle = .none
        
        headerLabel?.text = nameHeaderText
        
        // Check Internet connection
        guard isNetworkReachable() == true  else {
            
            return
        }
        
        _getAllCategory { [weak self] _ in
            self?.categoryContainer = Category().allCategories()
            //                self?.spiner.stopAnimating()
            self?.tableView?.reloadData()
        }
        if let queue = inactiveQueue {
            queue.activate()
        }
    }
    
    // NotificationCenter
    func methodOfReceivedNotification(notification: Notification){
        _getAllCategory { [weak self] _ in
            self?.categoryContainer = Category().allCategories()
            //                self?.spiner.stopAnimating()
            self?.tableView?.reloadData()
        }
        if let queue = inactiveQueue {
            queue.activate()
        }
    }
    
    // MARK: Request for update DB
    var inactiveQueue: DispatchQueue!
    func _getAllCategory (_ completion: @escaping Block) {
        
        // Clean all DB
        Dispatch.mainQueue.async(){
            Category.delAllCategories()
        }
        
        let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .userInteractive, attributes: [.concurrent, .initiallyInactive])
        inactiveQueue = anotherQueue
        
        anotherQueue.async(execute: { [weak self] in
            let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
            UserRequest.getAllCategories(param as [String : AnyObject], completion: { json in
                json.forEach { _, json in
                    print ("CatVC🔴")
                    let id = String(describing:json["id"])
                    let created_at = String(describing:json["created_at"])
                    let icon = String(describing:json["icon"])
                    let name = String(describing:json["name"])
                    let units = String(describing:json["units"])
                    let category_id = String(describing:json["category_id"])
                    let image: Data? = nil
                    
                    Category.setupCategory(id: id, icon: icon, name: name, created_at: created_at, units: units, category_id: category_id, image: image)
                    
                    
                }
                completion()
                
                // NotificationCenter to Menu for update rows
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier2"), object: nil)
            })
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
            //cell.thubnailImageView?.image = UIImage(data: category.image ?? Data())
            cell.thubnailImageView?.sd_setImage(with: URL(string: (category.icon)))
            cell.nameLabel?.text = category.name
        }
        
        return cell
    }
    
    //MARK: Segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Check Internet connection
        guard isNetworkReachable() == true  else {
            Dispatch.mainQueue.async {
                let alert = UIAlertController(title: "Нет Интернет Соединения", message: "Убедитесь, что Ваш девайс подключен к сети интернет", preferredStyle: .alert)
                let OkAction = UIAlertAction(title: "Ok", style: .default) {action in
                    
                }
                alert.addAction(OkAction)
                alert.show()
            }
            return
        }
        
        // Check if category is null follow to WeightVC
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        UserRequest.getAllProductsCategory(categoryID: categoryContainer[indexPath.row].id , entryParams: param as [String : AnyObject], completion: {[weak self] json in
            if  json.isEmpty {
                
                // Check if WeightVC is null follow to ListVC
                let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79", "category_id" : self?.categoryContainer[indexPath.row].id]
                UserRequest.getWeightCategory(param as [String : AnyObject], completion: { json in
                    if  json[0].isEmpty {
                        
                        let listOfProductsByWeightViewController = Storyboard.ListOfWeightProducts.instantiate()
                        listOfProductsByWeightViewController.nameListsOfProductsHeaderText = self?.categoryContainer[indexPath.row].name
                        listOfProductsByWeightViewController.idPodcategory = self?.categoryContainer[indexPath.row].id
                        listOfProductsByWeightViewController.unitOfWeightForListOfProductsByWeightVC = self?.categoryContainer[indexPath.row].units
                        listOfProductsByWeightViewController.addToContainer()
                        
                    } else {
                        
                        guard let weightViewController = UIStoryboard.main["weight"] as? WeightViewController else { return }
                        weightViewController.unitOfWeight = (self?.categoryContainer[indexPath.row].units) ?? ""
                        weightViewController.nameWeightHeaderText = (self?.categoryContainer[indexPath.row].name) ?? ""
                        weightViewController.podCategory_id = (self?.categoryContainer[indexPath.row].id) ?? ""
                        weightViewController.addToContainer()
                    }
                })
                
            } else {
                // Follow  to PodCategoryVC
                self?.getWeigth(indexPath: indexPath)
            }
        })
    }
    
    func getWeigth(indexPath: IndexPath) {
        let categoryViewController = Storyboard.Category.instantiate()
        categoryViewController.unitsForWeightVC = categoryContainer[indexPath.row].units
        categoryViewController.categoryId = categoryContainer[indexPath.row].id
        categoryViewController.nameHeaderText = categoryContainer[indexPath.row].name
        categoryViewController.addToContainer()
    }
}

class CategoryViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var unitsForWeightVC: String?
    var nameHeaderText: String?
    var categoryId: String?
    @IBOutlet weak var headerLabel: UILabel?
    @IBOutlet weak var tableView: UITableView?
    //var spiner = UIActivityIndicatorView()
    internal var categories = [CategoryStruct]()
    internal var categoriesList = [CategoryStruct]()
    // If podcategoty is nul
    internal var categoryContainer2 = [Category]()
    
    override func viewDidLoad() {
        self.categoryContainer2 = Category().allCategories()
        tableView?.separatorStyle = .none
        headerLabel?.text = nameHeaderText
        spiner.hidesWhenStopped = true
        spiner.activityIndicatorViewStyle = .gray
        _ = view.add(spiner)
        spiner.center.x = view.center.x
        spiner.center.y = view.center.y - 170
        spiner.startAnimating()
        
        self.getAllCategory2({})
        
    }
    
    func getAllCategory2(_ completion: @escaping Block) {
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        guard let categoryId = categoryId else { return }
        UserRequest.getAllProductsCategory(categoryID: categoryId, entryParams: param as [String : AnyObject], completion: {[weak self] json in
            
            guard let weakSelf = self else {
                return
            }
            
            json.forEach { _, json in
                let id = json["id"].string ?? ""
                let category_id = json["category_id"].string ?? ""
                let created_at = json["created_at"].string ?? ""
                let icon = json["icon"].string ?? ""
                let name = json["name"].string ?? ""
                let units = json["units"].string ?? ""
                let image = Data()
                
                let category = CategoryStruct(id: id, icon: icon, name: name, created_at: created_at, units: units, category_id: category_id, image: image)
                self?.categories.append(category)
            }
            weakSelf.categoriesList = weakSelf.categories
            weakSelf.tableView?.reloadData()
            self?.spiner.stopAnimating()
        })
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CategoryTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CategoryTableViewCell
        
        let category = categoriesList[indexPath.row]
        Dispatch.mainQueue.async { _ in
            cell.thubnailImageView?.sd_setImage(with: URL(string: (category.icon)))
            cell.nameLabel?.text = category.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Check Internet connection
        guard isNetworkReachable() == true  else {
            Dispatch.mainQueue.async {
                let alert = UIAlertController(title: "Нет Интернет Соединения", message: "Убедитесь, что Ваш девайс подключен к сети интернет", preferredStyle: .alert)
                let OkAction = UIAlertAction(title: "Ok", style: .default) {action in
                    
                }
                alert.addAction(OkAction)
                alert.show()
            }
            return
        }
        
        
        // Check if WeightVC is null follow to ListVC
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79", "category_id" : categoriesList[indexPath.row].id]
        UserRequest.getWeightCategory(param as [String : AnyObject], completion: { json in
            if  json[0].isEmpty {
                
                let listOfProductsByWeightViewController = Storyboard.ListOfWeightProducts.instantiate()
                listOfProductsByWeightViewController.nameListsOfProductsHeaderText = self.categoriesList[indexPath.row].name
                listOfProductsByWeightViewController.idPodcategory = self.categoriesList[indexPath.row].id
                listOfProductsByWeightViewController.unitOfWeightForListOfProductsByWeightVC = self.categoriesList[indexPath.row].units
                listOfProductsByWeightViewController.addToContainer()
                
            } else {
                
                guard let weightViewController = UIStoryboard.main["weight"] as? WeightViewController else { return }
                weightViewController.unitOfWeight = (self.categoriesList[indexPath.row].units)
                weightViewController.nameWeightHeaderText = (self.categoriesList[indexPath.row].name)
                weightViewController.podCategory_id = (self.categoriesList[indexPath.row].id)
                weightViewController.addToContainer()
            }
        })
        
    }
}

