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
    
    var products = [Product]()
    var searchProduct = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField?.addTarget(self, action: #selector(self.searchTextChanged(sender:)), for: .editingChanged)
        
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
                let category_name = json["category_name"].string ?? ""
                let price_sale = json["price_sale"].string ?? ""
                var image: Data? = nil
                if icon.isEmpty == false, let imageData = try? Data(contentsOf: URL(string: icon) ?? URL(fileURLWithPath: "")){
                    image = imageData
                }
                let product = Product.setupProduct(id: id, description_: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody, units: "", image: image)
                self?.searchProduct.append(product)
            }
            weakSelf.products = weakSelf.searchProduct
            weakSelf.tableView.reloadData()
        })
    }
    
    //for search
    func searchTextChanged(sender: UITextField) {
        if let text = sender.text {
            if text.isEmpty {
                products = searchProduct;
            } else {
                products =  self.searchProduct.filter { $0.name.lowercased().range(of: text, options: .caseInsensitive, range: nil, locale: nil) != nil }
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchViewController"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchTableViewCell
        
        let productDetails = products[indexPath.row]
        Dispatch.mainQueue.async { _ in
            cell.thubnailImageView?.image = UIImage(data: productDetails.image ?? Data())
        }
        
        cell.nameLabel?.text = productDetails.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
    }
}

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thubnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thubnailImageView?.layer.cornerRadius = 30
        thubnailImageView?.layer.masksToBounds = true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
