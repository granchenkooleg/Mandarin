//
//  Reachability.swift
//  Mandarin
//
//  Created by Oleg on 3/1/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import Foundation
import Alamofire

//import SystemConfiguration



//    func connectedToNetwork() -> Bool {
//
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//
//        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
//            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
//                SCNetworkReachabilityCreateWithAddress(nil, $0)
//            }
//        }) else {
//            return false
//        }
//
//        var flags: SCNetworkReachabilityFlags = []
//        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
//            return false
//        }
//
//        let isReachable = flags.contains(.reachable)
//        let needsConnection = flags.contains(.connectionRequired)
//
//        return (isReachable && !needsConnection)
//    }



private let manager = NetworkReachabilityManager(host: "www.bez-paketov.ru")

let reachabilityManager = NetworkReachabilityManager(host: "www.bez-paketov.ru")

func listenForReachability() {
    reachabilityManager?.listener = { status in
        print("Network Status Changed: \(status)")
        switch status {
//        case .notReachable:
//            //Show error state
//            let alert = UIAlertController(title: "Нет Интернет Соединения", message: "Убедитесь, что Ваш девайс подключен к сети интернет", preferredStyle: .alert)
//            let OkAction = UIAlertAction(title: "Ok", style: .default) {action in
//                
//            }
//            alert.addAction(OkAction)
//            alert.show()
        case .reachable:
            //Hide error state
            print("Internet connection")
        default: print ("")
        }
        
    }
    
    reachabilityManager?.startListening()
}

func isNetworkReachable() -> Bool {
    return manager?.isReachable ?? false
}
