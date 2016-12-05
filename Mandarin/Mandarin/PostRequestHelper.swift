//
//  PostRequestHelper.swift
//  Mandarin
//
//  Created by Oleg on 12/6/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Foundation

protocol EntryParametersPresenting {
    var params: [String: AnyObject] { get }
}

struct FBEntry: EntryParametersPresenting {
    var params: [String : AnyObject]
    
    init(params: [String : AnyObject]) {
        self.params = params
        self.params["grant_type"] = "facebook" as AnyObject?
        self.params["cliend_id"] = Constants.FBClientID as AnyObject?
        self.params["client_secret"] = Constants.FBClientSecret as AnyObject?
    }
}

struct LoginEntry: EntryParametersPresenting {
    var params: [String : AnyObject]
    
    init(params: [String : AnyObject]) {
        self.params = params
        let deviceID = GUID()
        UserDefaults.standard.setValue(["device_id": deviceID], forKey: "deviceID")
        Logger.log("DeviceID - \(deviceID)", color: .Orange)
        let timestamp = Int(Date().timeIntervalSince1970)
        self.params["md"] = timestamp as AnyObject?
        self.params["device_id"] = deviceID as AnyObject?
        let checksum = String(format: "doumxc914!\(timestamp)").md5()
        self.params["checksum"] = checksum as AnyObject?
        
    }
}

struct TransEntry: EntryParametersPresenting {
    var params: [String : AnyObject]
}

struct TrandEntry: EntryParametersPresenting {
    var params: [String : AnyObject]
    
    init(params: [String : AnyObject]) {
        self.params = params
        self.params["user_id"] = User.currentUser?.id as AnyObject?? ?? "" as AnyObject?
    }
}

struct AmountEntry: EntryParametersPresenting {
    var params: [String : AnyObject]
    
    init(params: [String : AnyObject]) {
        self.params = params
        self.params["user_id"] = User.currentUser?.id as AnyObject?? ?? "" as AnyObject?
    }
}

