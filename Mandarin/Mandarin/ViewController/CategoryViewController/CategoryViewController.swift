//
//  CategoryViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/30/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class CategoryViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var internalProducts: [Products] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for dictionary in Feeds.products {
            let name  =   dictionary["name"] as? String ?? ""
            let capacity = dictionary ["capacity"] as? Int ?? 0
            let photo = dictionary["photo"] as? String ?? ""
            let description = dictionary["description"] as? String ?? ""
            let price = dictionary["price"] as? Int ?? 0
            let manufacturer  =   dictionary["manufacturer"] as? String ?? ""
            let calories = dictionary["ccalories"] as? Int ?? 0
            let proteins = dictionary["proteins"] as? Int ?? 0
            let fats = dictionary["fats"] as? Int ?? 0
            let carbohydrates = dictionary["carbohydrates"] as? Int ?? 0
            let specialPrice = dictionary["specialPrice"] as? Int ?? 0
            let weightOfgoods = dictionary["weightOfgoods"] as? Int ?? 0
            
            let product = Products(price: price, name: name, photo: photo, description: description, manufacturer: manufacturer, capacity: capacity,  calories: calories, proteins: proteins, fats: fats, carbohydrates: carbohydrates, specialPrice: specialPrice, weightOfgoods: weightOfgoods)
            internalProducts.append(product)
        }
        
        _products = internalProducts
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
        
        let productDetails = _products[(indexPath as NSIndexPath).row]
        cell.thubnailImageView?.image = UIImage(named: productDetails.photo)
        cell.nameLabel?.text = productDetails.name
        
        return cell
    }
    
    override func searchTextChanged(sender: UITextField) {
        if let text = sender.text {
            if text.isEmpty {
                _products = internalProducts;
            } else {
                _products =  self.internalProducts.filter { $0.name.lowercased().range(of: text, options: .caseInsensitive, range: nil, locale: nil) != nil }
            }
        }
        tableView.reloadData()
    }
}

