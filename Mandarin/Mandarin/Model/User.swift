
//  User.swift
//  Mandarin
//
//  Created by Macostik on 12/3/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

var token: NotificationToken?

class User: Object {
    
    dynamic var id: String? = "" // or dynamic var id = UUID().uuidString
    dynamic var firstName: String? = ""
    dynamic var lastName: String? = ""
    dynamic var email: String? = ""
    dynamic var password: String? = ""
    dynamic var phone: String? = ""
    var products = List<ProductsForRealm>()
    var homeUserData = List<InfoAboutUserForOrder>()
    

    override static func primaryKey() -> String? {
        return "id"
    }
    
    deinit {
    }
    
    static func setConfig() {
        let realm = try! Realm()
        if let url = realm.configuration.fileURL {
            print("FileURL of DataBase - \(url)")
        }
    }
    
    class func setupUser(id: String = "", firstName: String = "", lastName: String = "", email: String = "", phone: String = "") {
        
        setConfig()
        
        let userData: Dictionary = [
            "id" :          id,
            "firstName" :   firstName,
            "lastName" :    lastName,
            "email" :       email,
            "phone" :       phone]
        
        let user = User(value: userData)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(user, update: true)
        }
    }
    
    static var currentUser: User? = {
        let realm = try! Realm()
        let user = realm.objects(User.self).first
        
        return user
    }()
    
    static func deleteUser() {
        let realm = try! Realm()
        guard let user = realm.objects(User.self).first else { return }
        try! realm.write {
            realm.delete(user)
        }
    }
    
    func fullName() -> String {
        return (firstName ?? "") + " " + (lastName ?? "")
    }
    
    func save() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(User.currentUser ?? User(), update: true)
        }
    }
    
    class func isAuthorized() -> Bool {
        let realm = try! Realm()
        
        guard let user = realm.objects(User.self).first, user.id?.isEmpty == false else { return false }
        return true
    }
}

