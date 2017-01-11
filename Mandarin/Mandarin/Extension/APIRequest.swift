//
//  APIRequest.swift
//  BinarySwipe
//
//  Created by Yuriy on 6/16/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

func requestHandler(_ function: Any, URLRequest: URLRequestConvertible, completionHandler: @escaping (JSON?) -> Void) {
    
    let params = try? JSONSerialization.jsonObject(with: URLRequest.urlRequest?.httpBody ?? Data())
    Logger.log("API call \(function) \(URLRequest.urlRequest?.httpMethod) \(URLRequest.urlRequest?.url): \(params ?? NSNull())", color: .Yellow)
    
    Alamofire.request(URLRequest)
        .validate()
        .responseJSON { response in
            var errorDescription = ""
            var errorReason = ""
            if case let .failure(error) = response.result {
                if let error = error as? AFError {
                    switch error {
                    case .invalidURL(let url):
                        errorReason = "Invalid URL: " + "\(url) - \(error.localizedDescription)"
                    case .parameterEncodingFailed(let reason):
                        errorDescription = "Parameter encoding failed: " + "\(error.localizedDescription)"
                        errorReason = "Failure Reason: " + "\(reason)"
                    case .multipartEncodingFailed(let reason):
                        errorDescription = "Multipart encoding failed: " + "\(error.localizedDescription)"
                        errorReason = "Failure Reason: " + "\(reason)"
                    case .responseValidationFailed(let reason):
                        errorDescription = "Response validation failed: " + "\(error.localizedDescription)"
                        errorReason = "Failure Reason: " + "\(reason)"
                        
                        switch reason {
                        case .dataFileNil, .dataFileReadFailed:
                            errorDescription = "Downloaded file could not be read"
                        case .missingContentType(let acceptableContentTypes):
                            errorDescription = "Content Type Missing: " + "\(acceptableContentTypes)"
                        case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                            errorDescription = "Response content type: " + "\(responseContentType) " + "was unacceptable: " + "\(acceptableContentTypes)"
                        case .unacceptableStatusCode(let code):
                            errorDescription = "Response status code was unacceptable: " + "\(code)"
                        }
                    case .responseSerializationFailed(let reason):
                        errorDescription = "Response serialization failed: " + "\(error.localizedDescription)"
                        errorReason = "Failure Reason: " + "\(reason)"
                    }
                    
                    errorDescription =  "Underlying error: " + "\(error.underlyingError)"
                } else if let error = error as? URLError {
                    errorDescription = "URLError occurred: " + "\(error)"
                } else {
                    errorDescription = "Unknown error: " + "\(error)"
                }
                Logger.log(errorDescription + errorReason, color: .Red)
                UIAlertController.alert(String(format: errorDescription), message: errorReason).show()
                completionHandler(nil)
            }
            
            if case let .success(value) = response.result {
                let json = JSON(value)
                Logger.log("RESPONSE - \(json)", color: .Green)
                completionHandler(json)
            }
    }
}

let encodedRequestHalper: ((HTTPMethod, [String: AnyObject]?, URL) throws -> URLRequest) = { method, parameters, url in
    var _urlRequest = URLRequest(url: url)
    
    _urlRequest.httpMethod = method.rawValue
    return try URLEncoding.default.encode(_urlRequest, with: parameters)
}

enum UserRequest: URLRequestConvertible {
    
    case addOrderToSite([String: AnyObject])
    case favoriteProduct([String: AnyObject])
    case addFavoriteProduct([String: AnyObject])
    case getPassword([String: AnyObject])
    case getAllProducts([String: AnyObject])
    case getWeight([String: AnyObject])
    case getCategories([String: AnyObject])
    case getProductsCategory(String, [String: AnyObject])
    case registration([String: AnyObject])
    case login([String: AnyObject])
    case logOut(String)
    case statistics(String)
    case trades(String)
    case trans(String, [String: AnyObject])
    case amount([String: AnyObject])
    
    func asURLRequest() throws -> URLRequest {
        
        var method: HTTPMethod {
            switch self {
            case .statistics, .trades, .amount, .login, .getProductsCategory, .getCategories, .registration, .getWeight, .getAllProducts, .getPassword, .addFavoriteProduct, .favoriteProduct, .addOrderToSite:
                return .get
            case .logOut, .trans:
                return .post
            }
        }
        
        let params: ([String: AnyObject]?) = {
            switch self {
                
            case .addOrderToSite(let newPost):
                return newPost
            case .favoriteProduct(let newPost):
                return newPost
            case .addFavoriteProduct(let newPost):
                return newPost
            case .getPassword(let newPost):
                return newPost
            case .getAllProducts(let newPost):
                return newPost
            case .getWeight(let newPost):
                return newPost
            case .logOut, .statistics, .trades:
                return (nil)
            case .getCategories(let newPost):
                return newPost
            case .getProductsCategory(_, let newPost):
                return newPost
            case .registration(let newPost):
                return newPost
            case .trans( _, let newPost):
                return  newPost
            case .login(let newPost):
                return newPost
            case .amount(let newPost):
                return newPost
            }
        }()
        
        let url: URL = {
            let relativePath:String?
            switch self {
              
            case.addOrderToSite:
                relativePath = "addOrder"
            case.favoriteProduct:
                relativePath = "favorite"
            case.addFavoriteProduct:
                relativePath = "addFavorite"
            case.getPassword:
                relativePath = "restorePass"
            case .getAllProducts:
                relativePath = "products"
            case .getWeight:
                relativePath = "weight"
            case .getCategories:
                relativePath = "categories"
            case .getProductsCategory(let categoryIdentifier, _):
                relativePath = "subcategories/\(categoryIdentifier)"
            case .registration:
                relativePath = "registration"
            case .login:
                relativePath = "login"
            case .logOut(let userIdentifier):
                relativePath = "logout/\(userIdentifier)"
            case .statistics(let userIdentifier):
                relativePath = "users/statistics/\(userIdentifier)"
            case .trades(let userIdentifier):
                relativePath = "users/\(userIdentifier)/trades"
            case .trans(let trans, _):
                relativePath = "users/\(trans)"
            case .amount:
                relativePath = "change_amount"
            }
            
            var URL = Foundation.URL(string: Constants.baseURLString)!
            if let relativePath = relativePath {
                URL = URL.appendingPathComponent(relativePath)
            }
            return URL
        }()
        
        return try encodedRequestHalper(method, params, url)
    }
    
    //    static func creteUserForTranse(_ _trans: String, completion: @escaping Block) {
    //        guard let uid = UserDefaults.standard.value(forKey: "deviceID") as? [String : AnyObject] else { return }
    //        let transEntry = TransEntry(params: uid)
    //        requestHandler(#function, URLRequest: trans(_trans, transEntry.params), completionHandler: { json in
    //            setupUser(json)
    //
    //            completion()
    //        })
    //    }
    //
    //    static func createUser(_ entryParams: EntryParametersPresenting, completion: @escaping Block) {
    //        requestHandler(#function, URLRequest: create(entryParams.params)) { json in
    //            setupUser(json)
    //            completion()
    //        }
    //    }
    //
    
    
    static func addOrderToServer(_ entryParams: [String : AnyObject], completion: @escaping (Bool) -> Void) {
        requestHandler(#function, URLRequest: addOrderToSite(entryParams)) { json in
            guard let json = json else {
                completion(false)
                return
            }
            print (">>addOrderToServer - \(json)<<")
            completion(true)
        }
    }
    
    
    static func favorite(_ entryParams: [String : AnyObject], completion: @escaping (JSON) -> Void) {
        requestHandler(#function, URLRequest: favoriteProduct(entryParams), completionHandler: { json in
            guard let json = json else {
                return
            }
            print (">>favorite - \(json)<<")
            completion(json)
        })
    }
    
    static func addToFavorite(_ entryParams: [String : AnyObject], completion: @escaping (Bool) -> Void) {
        requestHandler(#function, URLRequest: addFavoriteProduct(entryParams)) { json in
            
            ///! omission in "successful " here spetial! So it is in the server!
            if json?[0]["message"] == "successful "  {
                print (">>addToFavorite - \(json?[0]["message"])<<")
                //            User.setupUser(id: "\(json[0]["data"]["id"])", firstName: "\(json[0]["data"]["username"])")
                completion(true)
                ///! omission in "Product remove from favorite list " here spetial! So it is in the server!
            } else if json?[0]["message"] == "Product remove from favorite list " {
                print (">>addToFavorite - \(json?[0]["message"])<<")
                //            User.setupUser(id: "\(json[0]["data"]["id"])", firstName: "\(json[0]["data"]["username"])")
                completion(true)

            } else {
                print (">>addToFavorite - \(json?[0]["message"])<<")
                UIAlertController.alert("Этот продукт был уже добавлен в избранное, вами ранее!".ls).show()
                completion(false)
                return
            }
        }
    }
    
    static func getWeightCategory(_ entryParams: [String : AnyObject], completion: @escaping (JSON) -> Void) {
        requestHandler(#function, URLRequest: getWeight(entryParams), completionHandler: { json in
            guard let json = json else {
                return
            }
            completion(json)
        })
    }
    
    static func recoveryPassword(_ entryParams: [String : AnyObject], completion: @escaping (Bool) -> Void) {
        requestHandler(#function, URLRequest: getPassword(entryParams)) { json in
            guard let json = json else {
                completion(false)
                return
            }
            print (">>recoveryPassword - \(json)<<")
            User.deleteUser()
            completion(true)
        }
    }
    
    static func listAllProducts(_ entryParams: [String : AnyObject], completion: @escaping (JSON) -> Void) {
        requestHandler(#function, URLRequest: getAllProducts(entryParams), completionHandler: { json in
            guard let json = json else {
                return
            }
            completion(json)
        })
    }
    
    static func getAllCategories(_ entryParams: [String : AnyObject], completion: @escaping (JSON) -> Void) {
        requestHandler(#function, URLRequest: getCategories(entryParams), completionHandler: { json in
            guard let json = json else {
                return
            }
            completion(json)
        })
    }
    
    static func getAllProductsCategory(categoryID: String, entryParams: [String : AnyObject], completion: @escaping (JSON) -> Void) {
        requestHandler(#function, URLRequest: getProductsCategory(categoryID, entryParams), completionHandler: { json in
            guard let json = json else {
                return
            }
            completion(json)
        })
    }
    
    static func makelogin(_ entryParams: [String : AnyObject], completion: @escaping (Bool) -> Void) {
        requestHandler(#function, URLRequest: login(entryParams)) { json in
            guard let json = json, json[0]["error"] == false else {
                UIAlertController.alert("Введите корректные данные!".ls).show()
                completion(false)
                return
            }
            print (">>makelogin - \(json)<<")
            User.setupUser(id: "\(json[0]["data"]["id"])", firstName: "\(json[0]["data"]["username"])")
            completion(true)
        }
    }
    
    static func makeRegistration(_ entryParams: [String : AnyObject], completion: @escaping (Bool) -> Void) {
        requestHandler(#function, URLRequest: registration(entryParams)) { json in
            guard let json = json/*, json[0]["error"] == false*/ else {
                UIAlertController.alert("ошибка APIRequest".ls).show()
                completion(false)
                return
            }
            print (">>registration - \(json)<<")
            User.setupUser(id: "\(json[0]["data"]["id"])", firstName: "\(json[0]["data"]["username"])")
            completion(true)
        }
    }
    //
    //    static func logoutUser() {
    //        guard let saveDeviceID = UserDefaults.standard.value(forKey: "deviceID") as? [String: Any],
    //            let deviceID = saveDeviceID["device_id"] as? String else { return }
    //        requestHandler(#function, URLRequest: logOut(deviceID)) { json in
    //
    //        }
    //    }
    //
    //    static func getStatistics() {
    //        guard let id = User.currentUser?.id , id.isEmpty == false else { return }
    //        requestHandler(#function, URLRequest: statistics(id)) { json in
    //            if let json = json {
    //                   User.currentUser?.addStatistic(json)
    //            }
    //        }
    //    }
    //
    //    static func getTrades(_ completion: @escaping (JSON?) -> Void) {
    //        guard let id = User.currentUser?.id , id.isEmpty == false else { return }
    //        requestHandler(#function, URLRequest: trades(id), completionHandler: completion)
    //    }
    //
    //    static func updateAmount(_ entryParams: EntryParametersPresenting, completion: ((Bool) -> Void)? = nil) {
    //        requestHandler(#function, URLRequest: amount(entryParams.params), completionHandler: { json in
    //            if let array = json?.array {
    //                completion?(array.isEmpty)
    //            }
    //        })
    //    }
}

enum SignalRequest: URLRequestConvertible {
    
    case retrieves(String)
    case trades([String: AnyObject])
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .retrieves:
                return .get
            case .trades:
                return .post
            }
        }
        
        let params: ([String: AnyObject]?) = {
            switch self {
            case .retrieves:
                return (nil)
            case .trades(let newPost):
                return (newPost)
            }
        }()
        
        let url: URL = {
            let relativePath:String?
            switch self {
            case .retrieves(let strategyId):
                relativePath = "signals/retrieves/\(strategyId)"
            case .trades:
                relativePath = "signals/trades/"
            }
            
            var URL = Foundation.URL(string: Constants.baseURLString)!
            if let relativePath = relativePath {
                URL = URL.appendingPathComponent(relativePath)
            }
            return URL
        }()
        
        return try encodedRequestHalper(method, params, url)
    }
    
    //    static func aproveTrade(_ completion: @escaping (JSON?) -> Void) {
    //        let signal = Signal.sharedInctance
    //        let isCall = NSNumber(value: signal.isCall ?? false)
    //        let trandEntry = TrandEntry(params: ["is_call" : isCall,
    //                                            "option_id" : signal.optionID as AnyObject? ?? "" as AnyObject,
    //                                            "expiry_date" : signal.remainsAfter as AnyObject,
    //                                            "asset_name" : signal.asset as AnyObject,
    //                                            "amount" : signal.profit as AnyObject])
    //        requestHandler(#function, URLRequest: trades(trandEntry.params), completionHandler: completion)
    //    }
    //
    //    static func retrievesTrade(_ completion: @escaping (JSON?) -> Void) {
    //        guard let id = User.currentUser?.strategy_id , id.isEmpty == false else { return }
    //        requestHandler(#function, URLRequest: retrieves(id), completionHandler: completion
    //    }
}

enum TradesRequest: URLRequestConvertible {
    
    case get(String)
    case historyTrades(String)
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .get, .historyTrades:
                return .get
            }
        }
        
        let params: ([String: AnyObject]?) = {
            switch self {
            case .get, .historyTrades:
                return (nil)
            }
        }()
        
        let url: URL = {
            let relativePath:String?
            switch self {
            case .get(let userIdentifier):
                relativePath = "trades/retrieve/\(userIdentifier)"
            case .historyTrades(let userIdentifier):
                relativePath = "users/trades/\(userIdentifier)"
            }
            
            var URL = Foundation.URL(string: Constants.baseURLString)!
            if let relativePath = relativePath {
                URL = URL.appendingPathComponent(relativePath)
            }
            return URL
        }()
        
        return try encodedRequestHalper(method, params, url)
    }
    
    static func getHighRatedTrade(_ completion: @escaping (JSON?) -> Void) {
        //        guard let id = User.currentUser?.id , id.isEmpty == false else { return }
        //        requestHandler(#function, URLRequest: get(id), completionHandler: completion)
    }
    
    static func getHistoryTrades(_ completion: @escaping (JSON?) -> Void)  {
        //        guard let id = User.currentUser?.id , id.isEmpty == false else { return }
        //        requestHandler(#function, URLRequest: historyTrades(id), completionHandler: completion)
    }
}
