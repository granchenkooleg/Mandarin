//
//  ProductsForRealm.swift
//  Bezpaketov
//
//  Created by Oleg on 12/25/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class ProductsForRealm : Object {
    
    dynamic var quantity = ""
    dynamic var id: String = ""
    dynamic var descriptionForProduct: String? = ""
    dynamic var proteins: String? = ""
    dynamic var calories: String? = ""
    dynamic var zhiry: String? = ""
    dynamic var favorite: String? = ""
    dynamic var category_id: String? = ""
    dynamic var brand: String? = ""
    dynamic var price_sale: String? = ""
    dynamic var weight: String? = ""
    dynamic var status: String? = ""
    dynamic var expire_date: String? = ""
    dynamic var price: String? = ""
    dynamic var created_at: String? = ""
    dynamic var icon: String? = ""
    dynamic var category_name: String? = ""
    dynamic var name: String? = ""
    dynamic var uglevody: String? = ""
    dynamic var units: String? = ""
    dynamic var image: Data? = nil
    //dynamic var created = Date()
    
    dynamic var owner: User?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //path to Realm
    static func setConfig() {
        let realm = try! Realm()
        if let url = realm.configuration.fileURL {
            print("FileURL of DataBase - \(url)")
        }
    }
    
    class func setupProduct(id: String = "", descriptionForProduct: String = "", proteins: String = "", calories: String = "", zhiry: String = "", favorite: String = "", category_id: String = "", brand: String = "", price_sale: String = "", weight: String = "", status: String = "", expire_date: String = "", price: String = "", created_at: String = "", icon: String = "", category_name: String = "", name: String = "", uglevody: String = "", units: String = "", quantity: String = "", image: Data? = nil) -> ProductsForRealm {
        
        let productData: Dictionary <String, Any> = [
            "id" : id,
            "descriptionForProduct" : descriptionForProduct,
            "proteins" : proteins,
            "calories" : calories,
            "zhiry" : zhiry,
            "favorite" : favorite,
            "category_id" : category_id,
            "brand" : brand,
            "price_sale" : price_sale,
            "weight" : weight,
            "status" : status,
            "expire_date" : expire_date,
            "price" : price,
            "created_at" : created_at,
            "icon" : icon,
            "category_name" : category_name,
            "name" : name,
            "uglevody" : uglevody,
            "units" : units,
            "quantity" : quantity,
            "image": image ?? Data()]
        
        let product = ProductsForRealm(value: productData)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(product, update: true)
        }
        return product
    }
    
    static func deleteAllProducts() {
        let realm = try! Realm()
        let allProducts = realm.objects(ProductsForRealm.self)
        try! realm.write {
            realm.delete(allProducts)
        }
    }
}
