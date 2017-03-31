//
//  Reachability.swift
//  Bezpaketov
//
//  Created by Oleg on 3/1/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import Foundation
import Alamofire

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
