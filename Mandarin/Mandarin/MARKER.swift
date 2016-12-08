////
////  MARKER.swift
////  Mandarin
////
////  Created by Oleg on 12/8/16.
////  Copyright © 2016 Oleg. All rights reserved.
////
//
//import Foundation
//
//struct Products: FeedsForProducts {
//    var id = ""
//    var description = ""
//    var proteins = ""
//    var calories = ""
//    var zhiry = ""
//    var favorite = ""
//    var category_id = ""
//    var brand = ""
//    var weight = ""
//    var status = ""
//    var expire_date = ""
//    var price = ""
//    var created_at = ""
//    var icon = ""
//    var category_name = ""
//    var name = ""
//    var uglevody = ""
//    var price_sale = ""
//    
//    
//    //    init(name: String, age: Int, photo: String, description: String, remainedMe: Bool = false) {
//    //            self.name = name   //        self.age = age
//    //            self.photo = photo
//    //            self.description = description
//    //            self.remainedMe = remainedMe
//    //        }
//}
//
/////////////////////////////////////////////////////////////
//
//
//var internalProductsForListOfWeightVC = [String]()
//var _productsList = [String]()
//
//override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    // Do any additional setup after loading the view.
//    let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
//    UserRequest.listAllProducts(param as [String : AnyObject], completion: {[weak self] json in
//        json.forEach { _, json in
//            print (">>self - \(json["name"])<<")
//            let id = json["id"].string ?? ""
//            let created_at = json["created_at"].string ?? ""
//            let icon = json["icon"].string ?? ""
//            let name = json["name"].string ?? ""
//            let category_id = json["category_id"].string ?? ""
//            let weight = json["weight"].string ?? ""
//            let description = json["description"].string ?? ""
//            let brand = json["brand"].string ?? ""
//            let calories = json["calories"].string ?? ""
//            let proteins = json["proteins"].string ?? ""
//            let zhiry = json["zhiry"].string ?? ""
//            let uglevody = json["uglevody"].string ?? ""
//            let price = json["price"].string ?? ""
//            let favorite = json["favorite"].string ?? ""
//            let status = json["status"].string ?? ""
//            let expire_date = json["expire_date"].string ?? ""
//            let category_name = json["category_name"].string ?? ""
//            let price_sale = json["price_sale"].string ?? ""
//            
//            
//            /*!
//             *  Here we doing compare
//             *                              if idPodcategory == category_id && weightOfWeightVC == weightListOfProducts {
//             *  let category = Category(id: id, icon: icon, name: name, created_at: created_at, units: units, category_id: category_id /*,weight: weight*/)
//             *  self?.internalProducts.append(category)
//             *  } else { return }
//             *
//             */
//            
//            let list = Products (id: id, description: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody, price_sale: price_sale)
//            self?.internalProductsForListOfWeightVC.append(list)
//
//
//////////////////////////////////////////////////////////
//
//
