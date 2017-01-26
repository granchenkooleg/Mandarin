//
//  ListOfProductsByWeightViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/30/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class ListOfProductsByWeightViewControllerSegment: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listHeaderLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //segue
    var nameListsOfProductsHeaderText: String?
    var unitOfWeightForListOfProductsByWeightVC: String?
    //property for comparison with allListProducts and suitable data retrieval
    var weightOfWeightVC: String?
    var idPodcategory: String?
    
    var list: Any?
    var productsForListOfWeightVC = [Product]()
    var productsList = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listHeaderLabel?.text = nameListsOfProductsHeaderText
        
        // Do any additional setup after loading the view.
        listOfProduct()
        tableView.separatorStyle = .none
    }
    
    func listOfProduct() {
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        UserRequest.listAllProducts(param as [String : AnyObject], completion: {[weak self] json in
            guard let weakSelf = self else { return }
            json.forEach { _, json in
                print (">>self - \(json)<<")
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
                var image: Data? = nil
                if icon.isEmpty == false, let imageData = try? Data(contentsOf: URL(string: icon)!){
                    image = imageData
                }
                // It sort for segment "Скидки"
                if Double(price_sale)! > Double(0.00) {
                    self?.list = Product.setupProduct(id: id, description_: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody, units: "", image: image)
                    self?.productsForListOfWeightVC.append(self?.list as! Product)
                } else {return}
                
            }
            
            weakSelf.productsList = weakSelf.productsForListOfWeightVC
            weakSelf.tableView.reloadData()
            })
    }
    
    // MARK: - Table view data source
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ListOfProductsByWeightViewController"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ListOfProductsByWeightTableViewCell
        
        let productDetails = productsList[indexPath.row]
        Dispatch.mainQueue.async { _ in
            cell.thubnailImageView?.image = UIImage(data: productDetails.image ?? Data())
            
            
            cell.nameLabel?.text = productDetails.name
            cell.descriptionLabel?.text = productDetails.description_
            cell.weightLabel?.text = productDetails.weight + " " + (self.unitOfWeightForListOfProductsByWeightVC ?? "")
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
            }
        }
        return cell
    }
    
    
    // MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsProductVC = Storyboard.DetailsProduct.instantiate()
        detailsProductVC.idProductDetailsVC = productsList[indexPath.row].id
        detailsProductVC.priceDetailsVC = productsList[indexPath.row].price
        detailsProductVC.descriptionDetailsVC = productsList[indexPath.row].description
        detailsProductVC.uglevodyDetailsVC = productsList[indexPath.row].uglevody
        detailsProductVC.zhiryDetailsVC = productsList[indexPath.row].zhiry
        detailsProductVC.proteinsDetailsVC = productsList[indexPath.row].proteins
        detailsProductVC.caloriesDetailsVC = productsList[indexPath.row].calories
        detailsProductVC.expire_dateDetailsVC = productsList[indexPath.row].expire_date
        detailsProductVC.brandDetailsVC = productsList[indexPath.row].brand
        detailsProductVC.iconDetailsVC = productsList[indexPath.row].icon
        //detailsProductVC.DetailsVC = _products[indexPath.row].
        detailsProductVC.created_atDetailsVC = productsList[indexPath.row].created_at
        detailsProductVC.nameHeaderTextDetailsVC = productsList[indexPath.row].name
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
        containerViewController.addController(detailsProductVC)
    }
}

class ListOfProductsByWeightViewController: ListOfProductsByWeightViewControllerSegment {
    
    var products = [Product]()
    var _productsArray = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func listOfProduct() {
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        UserRequest.listAllProducts(param as [String : AnyObject], completion: {[weak self] json in
            guard let weakSelf = self else { return }
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
                
                
                var image: Data? = nil
                if icon.isEmpty == false, let imageData = try? Data(contentsOf: URL(string: icon)!){
                    image = imageData
                }
                let list = Product.setupProduct(id: id, description_: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody, units: "", image: image)
                self?._productsArray.append(list)
                
            }
            weakSelf.products = weakSelf._productsArray
            weakSelf.tableView.reloadData()
            })
    }
    
}
