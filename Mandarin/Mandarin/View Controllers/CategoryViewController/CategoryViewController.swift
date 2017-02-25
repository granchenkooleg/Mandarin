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
    //var spiner = UIActivityIndicatorView()
    
    //From segue
    var nameHeaderText: String?
    
    // @IBOutlet weak var tableView: UITableView!
    
    internal var categoryContainer = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.separatorStyle = .none
//        spiner.hidesWhenStopped = true
//        spiner.activityIndicatorViewStyle = .gray
//        _ = view.add(spiner)
//        spiner.center.x = view.center.x
//        spiner.center.y = view.center.y - 150
//        spiner.startAnimating()
        
        headerLabel?.text = nameHeaderText
//        let favoriteProducts = Category().allCategories()
//        guard favoriteProducts.count != 0 else {
            _getAllCategory { [weak self] _ in
                self?.categoryContainer = Category().allCategories()
//                self?.spiner.stopAnimating()
                self?.tableView?.reloadData()
            }
        if let queue = inactiveQueue {
            queue.activate()
        }
            
//            return
//        }
//        categoryContainer = favoriteProducts
        
//!!        spiner.stopAnimating()
        tableView?.reloadData()
    }
    
    // MARK: Request for update DB
    var inactiveQueue: DispatchQueue!
    func _getAllCategory (_ completion: @escaping Block) {
        let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .userInteractive, attributes: [.concurrent, .initiallyInactive])
        inactiveQueue = anotherQueue
        
        anotherQueue.async(execute: { [weak self] in
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        UserRequest.getAllCategories(param as [String : AnyObject], completion: { json in
            json.forEach { _, json in
                print ("CatVC🔴")
                let id = json["id"].string ?? ""
                let created_at = json["created_at"].string ?? ""
                let icon = json["icon"].string ?? ""
                let name = json["name"].string ?? ""
                let units = json["units"].string ?? ""
//                /////////
//                let searchVC = SearchViewController()
//                searchVC.unitOfWeightSearchVC = units
//                ////////
                let category_id = json["category_id"].string ?? ""
                var image: Data? = nil
                if icon.isEmpty == false, let imageData = try? Data(contentsOf: URL(string: icon) ?? URL(fileURLWithPath: "")){
                    image = imageData
                    Category.setupCategory(id: id, icon: icon, name: name, created_at: created_at, units: units, category_id: category_id, image: image)
                }
            }
            completion()
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
            cell.thubnailImageView?.image = UIImage(data: category.image ?? Data())
            cell.nameLabel?.text = category.name
        }
        
        return cell
    }
    
    //MARK: Segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getWeigth(indexPath: indexPath)
        //        toSearchVC(indexPath: indexPath)
    }
    
    func getWeigth(indexPath: IndexPath) {
        let categoryViewController = Storyboard.Category.instantiate()
        categoryViewController.categoryId = categoryContainer[indexPath.row].id
        categoryViewController.nameHeaderText = categoryContainer[indexPath.row].name
        categoryViewController.addToContainer()
    }
    
//    @IBAction func moveToSearch(sender: UIButton) {
//        
//        // Transfer units
//        let searchVC = SearchViewController()
//        
//        for i in categoryContainer {
//            searchVC.unitOfWeightSearchVC = ("\(i.units)<")
//            
//            guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
//            guard let searchVC = UIStoryboard.main["search"] as? SearchViewController else { return }
//            searchVC.unitOfWeightSearchVC = ("\(i.units)<")
//            containerViewController.addController(searchVC)
//        }
//    }
    
}

class CategoryViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var nameHeaderText: String?
    var categoryId: String?
    @IBOutlet weak var headerLabel: UILabel?
    @IBOutlet weak var tableView: UITableView?
    //var spiner = UIActivityIndicatorView()
    internal var categories = [CategoryStruct]()
    internal var categoriesList = [CategoryStruct]()
    
    override func viewDidLoad() {
        tableView?.separatorStyle = .none
        headerLabel?.text = nameHeaderText
        spiner.hidesWhenStopped = true
        spiner.activityIndicatorViewStyle = .gray
        _ = view.add(spiner)
        spiner.center.x = view.center.x
        spiner.center.y = view.center.y - 170
        spiner.startAnimating()
        Dispatch.backgroundQueue.after(0.03, block: { [weak self] in
            self?.getAllCategory2({})
        })
    }
    
    func getAllCategory2(_ completion: @escaping Block) {
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        guard let categoryId = categoryId else { return }
        UserRequest.getAllProductsCategory(categoryID: categoryId, entryParams: param as [String : AnyObject], completion: {[weak self] json in
            if  json.isEmpty {
                //It's null
                let alertController = UIAlertController(title: "У этой категории нет товара ", message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { action in

                    self?.backClick(nil)

//                    self?.dismiss(animated: true, completion: nil)
//                    UINavigationController.main.popViewController(animated: true)

                }
                alertController.addAction(OKAction)
                self?.present(alertController, animated: true)
                //self.dismiss(animated: true, completion: nil)
                self?.spiner.stopAnimating()
                return
            }
            
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
                
                var image = Data()
                if icon.isEmpty == false, let imageData = try? Data(contentsOf: URL(string: icon) ?? URL(fileURLWithPath: "")){
                    image = imageData
                }
                let category = CategoryStruct(id: id, icon: icon, name: name, created_at: created_at, units: units, category_id: category_id, image: image)
                self?.categories.append(category)
            }
            weakSelf.categoriesList = weakSelf.categories
            weakSelf.tableView?.reloadData()
            self?.spiner.stopAnimating()
            })
    }
    
    //segue
    func getWeigth(indexPath: IndexPath) {
        let weightViewController = Storyboard.Weight.instantiate()
        weightViewController.unitOfWeight = categoriesList[indexPath.row].units
        weightViewController.nameWeightHeaderText = categoriesList[indexPath.row].name
        weightViewController.podCategory_id = categoriesList[indexPath.row].id
        weightViewController.addToContainer()
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
            cell.thubnailImageView?.image = UIImage(data: category.image)
            cell.nameLabel?.text = category.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getWeigth(indexPath: indexPath)
    }
}

