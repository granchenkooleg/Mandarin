//
//  ListOfProductsByWeightViewController.swift
//  Bezpaketov
//
//  Created by Oleg on 11/30/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class ListOfProductsByWeightViewControllerSegment: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listHeaderLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var basketHandler: Block? = nil
    
    // Segue
    var nameListsOfProductsHeaderText: String?
    var unitOfWeightForListOfProductsByWeightVC: String?
    // Property for comparison with allListProducts and suitable data retrieval
    var weightOfWeightVC: String?
    var idPodcategory: String?
    
    var list: Any?
    var productsList = [Product]()
    
    var quantity: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Resize cell
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Spiner
        spiner.hidesWhenStopped = true
        spiner.activityIndicatorViewStyle = .gray
        view.add(spiner)
        spiner.center.x = view.center.x
        spiner.center.y = view.center.y - 150
        spiner.startAnimating()
        
        listHeaderLabel?.text = nameListsOfProductsHeaderText
        tableView.separatorStyle = .none
        
        // Do any additional setup after loading the view.
        let products = Product().allProducts()
        guard products.count != 0 else {
            
            // Check Internet connection
            guard isNetworkReachable() == true  else {
                Dispatch.mainQueue.async {
                    let alert = UIAlertController(title: "Нет Интернет Соединения", message: "Убедитесь, что Ваш девайс подключен к сети интернет", preferredStyle: .alert)
                    let OkAction = UIAlertAction(title: "Ok", style: .default) {action in
                        guard isNetworkReachable() == true  else {
                            self.present(alert, animated: true)
                            return
                        }
                        
                        // Call API method
                        self.listOfProduct {[weak self] _ in
                            self?.productsList = Product().allProducts().filter { Double($0.price_sale)! > Double(0.00) }
                            self?.tableView.reloadData()
                            self?.spiner.stopAnimating()
                        }
                    }
                    alert.addAction(OkAction)
                    alert.show()
                }
                spiner.stopAnimating()
                return
            }
            
            // Call API method
            listOfProduct {[weak self] _ in
                self?.productsList = Product().allProducts().filter { Double($0.price_sale)! > Double(0.00) }
                self?.tableView.reloadData()
                self?.spiner.stopAnimating()
            }
            return
        }
        productsList = products.filter { Double($0.price_sale)! > Double(0.00) }
        spiner.stopAnimating()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // For dynamic height cell
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    
    
    func listOfProduct(_ completion: @escaping Block)  {
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        UserRequest.listAllProducts(param as [String : AnyObject], completion: {json in
            json.forEach { _, json in
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
                var units = json["units"].string ?? ""
                if units == "kg" {
                    units = "кг."
                }
                if units == "liter" {
                    units = "л."
                }
                let category_name = json["category_name"].string ?? ""
                let price_sale = json["price_sale"].string ?? ""
                let image: Data? = nil
                
                Product.setupProduct(id: id, description_: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody, units: units, image: image)
            }
            completion()
        })
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ListOfProductsByWeightViewController"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ListOfProductsByWeightTableViewCell
        
        
        let productDetails = self.productsList[indexPath.row]
        
        cell.buttonAction = { [weak self]  (sender) in
            // Do whatever you want from your button here.
            let realm = try! Realm()
            if let product = realm.objects(ProductsForRealm.self).filter("id  == [c] %@", productDetails.id ).first {
                try! realm.write {
                    product.quantity = "\((Int((product.quantity)) ?? 0) + 1)"
                }
            } else {
                let image: Data? = nil
                
                let _ = ProductsForRealm.setupProduct(id: productDetails.id , descriptionForProduct: productDetails.description_ , proteins: productDetails.proteins , calories: productDetails.calories , zhiry: productDetails.zhiry , favorite: "", category_id: "", brand: productDetails.brand , price_sale: productDetails.price_sale , weight: "", status: "", expire_date: productDetails.expire_date , price: productDetails.price , created_at: productDetails.created_at , icon: productDetails.icon , category_name: "", name: productDetails.name , uglevody: productDetails.uglevody , units: "", quantity: "1", image: image)
            }
            
            Dispatch.mainQueue.async ({
                self?.updateProductInfo()
            })
            
            UIAlertController.alert("Товар добавлен в пакет".ls).show()
            self?.basketHandler?()
            
        }
        
        Dispatch.mainQueue.async { _ in
            cell.thubnailImageView?.sd_setImage(with: URL(string: (productDetails.icon)))
        }
        
        cell.nameLabel?.text = productDetails.name
        cell.descriptionLabel?.text = productDetails.description_
        cell.weightLabel?.text = productDetails.weight + " \(productDetails.units)"
        cell.priceOldLabel?.text = productDetails.price + " грн."
        
        // if price_sale != 0.00 грн, set it
        if productDetails.price_sale != "0.00" {
            cell.priceSaleLabel?.text = productDetails.price_sale +  "  грн."
            // Create attributed string for strikethroughStyleAttributeName
            let myString = productDetails.price + " грн."
            let myAttribute = [ NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue ]
            let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
            
            // Set attributed text on a UILabel
            cell.priceOldLabel?.attributedText = myAttrString
        } else {
            cell.priceSaleLabel?.text = ""
        }
        
        return cell
    }
    
    // MARK: - Navigation
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
        
        let detailsProductVC = Storyboard.DetailsProduct.instantiate()
        detailsProductVC.weightDetailsVC = productsList[indexPath.row].weight + " \(productsList[indexPath.row].units)"
        detailsProductVC.categoryIdProductDetailsVC = productsList[indexPath.row].category_id
        detailsProductVC.priceSaleDetailsVC = productsList[indexPath.row].price_sale
        detailsProductVC.idProductDetailsVC = productsList[indexPath.row].id
        detailsProductVC.priceDetailsVC = productsList[indexPath.row].price
        detailsProductVC.descriptionDetailsVC = productsList[indexPath.row].description_
        detailsProductVC.uglevodyDetailsVC = productsList[indexPath.row].uglevody
        detailsProductVC.zhiryDetailsVC = productsList[indexPath.row].zhiry
        detailsProductVC.proteinsDetailsVC = productsList[indexPath.row].proteins
        detailsProductVC.caloriesDetailsVC = productsList[indexPath.row].calories
        detailsProductVC.expire_dateDetailsVC = productsList[indexPath.row].expire_date
        detailsProductVC.brandDetailsVC = productsList[indexPath.row].brand
        detailsProductVC.iconDetailsVC = productsList[indexPath.row].icon
        detailsProductVC.created_atDetailsVC = productsList[indexPath.row].created_at
        detailsProductVC.nameHeaderTextDetailsVC = productsList[indexPath.row].name
        detailsProductVC.addToContainer()
    }
    
}

class ListOfProductsByWeightViewController: ListOfProductsByWeightViewControllerSegment {
    
    var products = [Product]()
    var _productsArray = [Product]()
    
    override func viewDidLoad() {
        
        // Resize dynamic cell
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        spiner.hidesWhenStopped = true
        spiner.activityIndicatorViewStyle = .gray
        view.add(spiner)
        spiner.center.x = view.center.x
        spiner.center.y = view.center.y
        spiner.startAnimating()
        
        
        listHeaderLabel?.text = nameListsOfProductsHeaderText
        tableView.separatorStyle = .none
        
        let products = Product().allProducts()
        guard products.count != 0 else {
            listOfProduct {[weak self] _ in
                self?.productsList = Product().allProducts().filter { (self?.idPodcategory == $0.category_id && self?.weightOfWeightVC == $0.weight)}
                if self?.productsList.isEmpty == true {
                    self?.productsList = products.filter {(self?.idPodcategory == $0.category_id && $0.weight == "")}
                }
                self?.tableView.reloadData()
                self?.spiner.stopAnimating()
            }
            
            return
        }
        
        
        
        productsList = products.filter {(self.idPodcategory == $0.category_id && self.weightOfWeightVC == $0.weight)}
        if productsList.isEmpty == true {
            productsList = products.filter {(self.idPodcategory == $0.category_id && $0.weight == "")}
        }
        if productsList.isEmpty == true {
            self.spiner.stopAnimating()
            let alertController = UIAlertController(title: "В этом разделе нет товара", message: "", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ок", style: .default) { action in
                self.backClick(nil)
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true)
            
            return
        }
        self.spiner.stopAnimating()
        tableView.reloadData()
    }
    
    // For dynamic height cell
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    
    override func listOfProduct(_ completion: @escaping Block) {
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        UserRequest.listAllProducts(param as [String : AnyObject], completion: {json in
            json.forEach { _, json in
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
                var units = json["units"].string ?? ""
                if units == "kg" {
                    units = "кг."
                }
                if units == "liter" {
                    units = "л."
                }
                let category_name = json["category_name"].string ?? ""
                let price_sale = json["price_sale"].string ?? ""
                var image: Data? = nil
                if icon.isEmpty == false, let imageData = try? Data(contentsOf: URL(string: icon) ?? URL(fileURLWithPath: "")){
                    image = imageData
                }
                Product.setupProduct(id: id, description_: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody, units: units, image: image)
            }
            completion()
        })
    }
    
}
