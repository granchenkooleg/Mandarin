//
//  AllProductsTableViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/23/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class AllProductsTableViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var products: [[String:Any]] = [
        [
            "name": "Крупы",
            "capacity": 500,
            "photo": "IconMandarin-76",
            "description": "Йогурт Активна с черносливом",
            "price": 222,
            "manufacturer": "Ukraine",
            "calories": 1000,
            "proteins": 23,
            "fats": 22,
            "carbohydrates": 122,
            "specialPrice": 100,
            "weightOfgoods": 550
            ],
        [
            "name": "Молочные изделия",
            "capacity": 500,
            "photo": "Icon-76",
            "description": "Йогурт Активна с черносливом",
            "price": 222,
            "manufacturer": "Ukraine",
            "calories": 1000,
            "proteins": 23,
            "fats": 22,
            "carbohydrates": 122,
            "specialPrice": 100,
            "weightOfgoods": 550
        ],
        
        [
            "name": "Консервация и соления",
            "capacity": 500,
            "photo": "IconMandarin-76",
            "description": "Йогурт Активна с черносливом",
            "price": 222,
            "manufacturer": "Ukraine",
            "calories": 1000,
            "proteins": 23,
            "fats": 22,
            "carbohydrates": 122,
            "specialPrice": 100,
            "weightOfgoods": 550,
            ],
        [
            "name": "Крупы",
            "capacity": 500,
            "photo": "IconMandarin-76",
            "description": "Йогурт Активна с черносливом",
            "price": 222,
            "manufacturer": "Ukraine",
            "calories": 1000,
            "proteins": 23,
            "fats": 22,
            "carbohydrates": 122,
            "specialPrice": 100,
            "weightOfgoods": 550
        ],
        [
            "name": "Молочные изделия",
            "capacity": 500,
            "photo": "Icon-76",
            "description": "Йогурт Активна с черносливом",
            "price": 222,
            "manufacturer": "Ukraine",
            "calories": 1000,
            "proteins": 23,
            "fats": 22,
            "carbohydrates": 122,
            "specialPrice": 100,
            "weightOfgoods": 550
        ],
        
        [
            "name": "Консервация и соления",
            "capacity": 500,
            "photo": "IconMandarin-76",
            "description": "Йогурт Активна с черносливом",
            "price": 222,
            "manufacturer": "Ukraine",
            "calories": 1000,
            "proteins": 23,
            "fats": 22,
            "carbohydrates": 122,
            "specialPrice": 100,
            "weightOfgoods": 550,
            ]

    ]
    
    fileprivate var internalProducts: [Products] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for dictionary in products {
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
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        
        return internalProducts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AllProductsTableViewCell
        
        // Configure the cell...
        
        let productDetails = internalProducts[(indexPath as NSIndexPath).row]
        cell.thubnailImageView?.image = UIImage(named: productDetails.photo)
        cell.nameLabel?.text = productDetails.name
        cell.capacityLabel?.text = "capacity:" + String(productDetails.capacity)
        cell.locationLabel?.text = productDetails.description
        
        return cell
    }
        
}
