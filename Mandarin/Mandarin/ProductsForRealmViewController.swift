//
//  ProductsForRealmViewController.swift
//  Mandarin
//
//  Created by Oleg on 12/25/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class ProductsForRealmViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        UserRequest.listAllProducts(param as [String : AnyObject], completion: {[weak self] json in
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
                
                
                let list = Product(id: id, description: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody, units: "")
                self?.internalProducts.append(list)
                
            }
            self?._products = (self?.internalProducts)!
            
            })
        let listForRealm = ProductsForRealm.setupProduct(id: "\(_products[0].id)", descriptionForProduct: "\(self._products[0].description)", proteins: "\(self._products[0].proteins)", calories: "\(self._products[0].calories)", zhiry: "\(self._products[0].zhiry)", favorite: "\(self._products[0].favorite)", category_id: "\(self._products[0].category_id)", brand: "\(self._products[0].brand)", price_sale: "\(self._products[0].price_sale)", weight: "\(self._products[0].weight)", status: "\(self._products[0].status)", expire_date: "\(self._products[0].expire_date)", price: "\(self._products[0].price)", created_at: "\(self._products[0].created_at)", icon: "\(self._products[0].icon)", category_name: "\(self._products[0].category_name)", name: "\(self._products[0].name)", uglevody: "\(self._products[0].uglevody)", units: "\(self._products[0].units)")
    }

}
