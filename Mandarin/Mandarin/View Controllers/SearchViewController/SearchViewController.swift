//
//  SearchViewController.swift
//  Bezpaketov
//
//  Created by Oleg on 12/18/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchTextField: TextField?
    
    var products = [Product]()
    var searchProduct = [Product]()
    
    var quantity: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Resize dynamic cell
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        spiner.hidesWhenStopped = true
        spiner.activityIndicatorViewStyle = .gray
        view.add(spiner)
        spiner.center.x = view.center.x
        spiner.center.y = view.center.y
        spiner.startAnimating()
        
        products = Product().allProducts()
        guard products.count != 0 else {
            searchRequest {[weak self] _ in
                self?.products = Product().allProducts()
                self?.searchProduct = self?.products ?? []
                self?.tableView.reloadData()
                self?.spiner.stopAnimating()
            }
            return
        }
        
        searchProduct = products
        spiner.stopAnimating()
        tableView.reloadData()
        
        searchTextField?.addTarget(self, action: #selector(self.searchTextChanged(sender:)), for: .editingChanged)
    }
    
    // For dynamic height cell
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    
    func searchRequest(_ completion: @escaping Block)  {
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        UserRequest.listAllProducts(param as [String : AnyObject], completion: { [weak self] json in
            guard let weakSelf = self else {return}
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
    
    func searchTextChanged(sender: UITextField) {
        if let text = sender.text {
            if text.isEmpty {
                searchProduct = products;
            } else {
                searchProduct =  products.filter { $0.name.lowercased().range(of: text, options: .caseInsensitive, range: nil, locale: nil) != nil }
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchViewController"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchTableViewCell
        
        let productDetails = searchProduct[indexPath.row]
        
        cell.buttonAction = { (sender) in
            // Do whatever you want from your button here.
            let realm = try! Realm()
            if let product = realm.objects(ProductsForRealm.self).filter("id  == [c] %@", productDetails.id ).first {
                try! realm.write {
                    product.quantity = "\((Int((product.quantity)) ?? 0) + 1)"
                }
            } else {
                let image: Data? = nil
                
                let _ = ProductsForRealm.setupProduct(id: productDetails.id , descriptionForProduct: productDetails.description_ , proteins: productDetails.proteins , calories: productDetails.calories , zhiry: productDetails.zhiry , favorite: "", category_id: "", brand: productDetails.brand , price_sale: productDetails.price_sale , weight: "", status: "", expire_date: productDetails.expire_date , price: productDetails.price , created_at: productDetails.created_at , icon: productDetails.icon , category_name: "", name: productDetails.name , uglevody: productDetails.uglevody , units: "", quantity: "\(self.quantity)", image: image)
            }
            
            UIAlertController.alert("Товар добавлен в пакет".ls).show()
            self.updateProductInfo()
        }
        
        Dispatch.mainQueue.async { _ in
            cell.thubnailImageView?.sd_setImage(with: URL(string: (productDetails.icon)))
        }
        
        cell.nameLabel?.text = productDetails.name
        cell.descriptionLabel?.text = productDetails.description_
        cell.weightLabel?.text = productDetails.weight + " \(productDetails.units)"
        cell.priceOldLabel?.text = productDetails.price + " грн."
        
        //if price_sale != 0.00 грн, set it
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
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
        detailsProductVC.weightDetailsVC = searchProduct[indexPath.row].weight + " " + searchProduct[indexPath.row].units
        detailsProductVC.categoryIdProductDetailsVC = searchProduct[indexPath.row].category_id
        detailsProductVC.priceSaleDetailsVC = searchProduct[indexPath.row].price_sale
        detailsProductVC.idProductDetailsVC = searchProduct[indexPath.row].id
        detailsProductVC.priceDetailsVC = searchProduct[indexPath.row].price
        detailsProductVC.descriptionDetailsVC = searchProduct[indexPath.row].description_
        detailsProductVC.uglevodyDetailsVC = searchProduct[indexPath.row].uglevody
        detailsProductVC.zhiryDetailsVC = searchProduct[indexPath.row].zhiry
        detailsProductVC.proteinsDetailsVC = searchProduct[indexPath.row].proteins
        detailsProductVC.caloriesDetailsVC = searchProduct[indexPath.row].calories
        detailsProductVC.expire_dateDetailsVC = searchProduct[indexPath.row].expire_date
        detailsProductVC.brandDetailsVC = searchProduct[indexPath.row].brand
        detailsProductVC.iconDetailsVC = searchProduct[indexPath.row].icon
        detailsProductVC.created_atDetailsVC = searchProduct[indexPath.row].created_at
        detailsProductVC.nameHeaderTextDetailsVC = searchProduct[indexPath.row].name
        
        self.present(detailsProductVC, animated: true)
    }
}

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet var buttonCart: UIButton!
    
    var buttonAction: ((_ sender: AnyObject) -> Void)?
    
    @IBAction func buttonPressedCart(_ sender: Any) {
        self.buttonAction?(sender as AnyObject)
    }
    
    @IBOutlet weak var thubnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var priceSaleLabel: UILabel!
    @IBOutlet weak var priceOldLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thubnailImageView?.layer.cornerRadius = 30
        thubnailImageView?.layer.masksToBounds = true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


