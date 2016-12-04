//
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
    
    dynamic var id: String? = ""
    dynamic var firstName: String? = ""
    dynamic var lastName: String? = ""
    dynamic var email: String? = ""
    dynamic var password: String? = ""
    dynamic var phone: String? = ""

    override static func primaryKey() -> String? {
        return "id"
    }
    
    deinit {
    }
    
    class func setupUser(id: String, firstName: String, lastName: String, email: String = "", phone: String = "") {
        
        let realm = try! Realm()
        if let url = realm.configuration.fileURL {
            Logger.log("FileURL of DataBase - \(url)", color: .Orange)
        }
        let userData: Dictionary = [
            "id" :          id,
            "firstName" :   firstName,
            "lastName" :    lastName,
            "email" :       email,
            "phone" :       phone]
        
        let user = User(value: userData)
        
        try! realm.write {
            realm.add(user, update: true)
        }
    }
    
    static var currentUser: User? = {
        let realm = try! Realm()
        let user = realm.objects(User.self).first
        
        return user
    }()
    
    class func createUserWithJSON(_ json: JSON) {
//        guard let accessToken = json["access_token"].string else { return }
//        UserDefaults.standard.setValue(accessToken, forKey: "user_auth_token")
//        Logger.log("AccessToken - \(accessToken)", color: .Orange)
        
        let userData: Dictionary = [
            "id" :          json["id"].string ?? "",
            "firstName" :   json["first_name"].string ?? "",
            "lastName" :    json["last_name"].string ?? "",
            "email" :       json["email"].string ?? "",
            "phone" :       json["phone"].string ?? ""]
        
        let user = User(value: userData)
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(user, update: true)
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
        
        guard let user = realm.objects(User.self).first, user.firstName?.isEmpty == false && user.lastName?.isEmpty == false else { return false }
        return true
    }
}

