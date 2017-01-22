//
//  InfoAboutUserForOrder.swift
//  Mandarin
//
//  Created by Oleg on 1/7/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class InfoAboutUserForOrder : Object {
    
    dynamic var idOrder = UUID().uuidString
    dynamic var name: String = ""
    dynamic var phone: String = ""
    dynamic var city: String? = ""
    dynamic var region: String? = ""
    dynamic var street: String? = ""
    dynamic var house: String? = ""
    dynamic var porch: String? = ""
    dynamic var apartment: String? = ""
    dynamic var floor: String? = ""
    dynamic var commit: String? = ""
    
    //dynamic var created = Date()
    
    dynamic var owner: User?
    
    override class func primaryKey() -> String? {
        return "idOrder"
    }

    
    //path to Realm
    static func setConfig() {
        let realm = try! Realm()
        if let url = realm.configuration.fileURL {
            print("FileURL of DataBase - \(url)")
        }
    }
    
    class func setupAllUserInfo(/*idOrder: String *//*= "",*/ name: String = "", phone: String = "", city: String = "", region: String = "", street: String = "", house: String = "", porch: String = "", apartment: String = "", floor: String = "", commit: String = "") {
        
        setConfig()
        
        let homeInfoUser: Dictionary = [
            /*"idOrder" : idOrder,*/
            "name" : name,
            "phone" : phone,
            "city" : city,
            "region" : region,
            "street" : street,
            "house" : house,
            "porch" : porch,
            "apartment" : apartment,
            "floor" : floor,
            "commit" : commit]
        
        let infoAboutUser = InfoAboutUserForOrder(value: homeInfoUser)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(infoAboutUser, update: true)
        }
    }
    
}
