//
//  SearchViewController.swift
//  Mandarin
//
//  Created by Oleg on 12/18/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchTextField: TextField?
    var spiner = UIActivityIndicatorView()
    
    // From CategoryVC
//    var unitOfWeightSearchVC : String?
    
    var products = [Product]()
    var searchProduct = [Product]()
    
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
                let units = json["units"].string ?? ""
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
        Dispatch.mainQueue.async { _ in
            cell.thubnailImageView?.image = UIImage(data: productDetails.image ?? Data())
        }
        
        cell.nameLabel?.text = productDetails.name
        cell.descriptionLabel?.text = productDetails.description_
        cell.weightLabel?.text = productDetails.weight + " " + productDetails.units 
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
        let detailsProductVC = Storyboard.DetailsProduct.instantiate()
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
        //detailsProductVC.DetailsVC = _products[indexPath.row].
        detailsProductVC.created_atDetailsVC = searchProduct[indexPath.row].created_at
        detailsProductVC.nameHeaderTextDetailsVC = searchProduct[indexPath.row].name
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
        dismiss(animated: true, completion: {
             containerViewController.addController(detailsProductVC)
        })
    }
}

class SearchTableViewCell: UITableViewCell {
    
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


