//
//  CheckViewController.swift
//  Bezpaketov
//
//  Created by Oleg on 12/8/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import RealmSwift



class CheckViewController: BasketViewController {
    
    @IBOutlet weak var numberOrderLabel: UILabel!
    @IBOutlet weak var dateOrderLabel: UILabel!
    @IBOutlet weak var nameCustomerLabel: UILabel!
    @IBOutlet weak var phoneCustomerLabel: UILabel!
    @IBOutlet weak var adressCustomerLabel: UILabel!
    @IBOutlet weak var amountMoneyOfOrderLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    
    // Segue
    var valueDeliveryTime: String = ""
    
    // Date
    func dateFormatter() -> String {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm"
        let dateString = dateFormatter.string(from: date as Date)
        // Custom Date Format  28-Feb-2016 11:41:51
        return String(dateString)
    }
    
    
    // It spetial for Realm
    var infoOfUser: Results<InfoAboutUserForOrder>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deliveryTimeLabel.text = (valueDeliveryTime + " мин.")
        
        // Realm start
        let realm = try! Realm()
        infoOfUser = realm.objects(InfoAboutUserForOrder.self)
        
        // Do any additional setup after loading the view.
        numberOrderLabel.text = infoOfUser.last?.idOrder
        nameCustomerLabel.text = infoOfUser.last?.name
        phoneCustomerLabel.text = infoOfUser.last?.phone
        
        adressCustomerLabel.text = "г. \(infoOfUser.last?.city ?? ""), " as String + "ул. \(infoOfUser.last?.street ?? ""), " as String + "дом. \(infoOfUser.last?.house ?? ""), " as String + "кв. \(infoOfUser.last?.apartment ?? "")" as String
        
        amountMoneyOfOrderLabel.text = (totalPriceInCart() + " грн.")
        dateOrderLabel.text = dateFormatter()
    }
    
    
    @IBAction func menuClickAndClearDatabase(_ sender: AnyObject) {
        
        ProductsForRealm.deleteAllProducts()
        updateProductInfo()
        
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
        containerViewController.showMenu(!containerViewController.showingMenu, animated: true)
    }
    
    // MARK: Sender to BasketVC
    @IBAction func showGoodsButton(_ sender: UIButton) {
        present(UIStoryboard.main["basketAfterpayment"]!, animated: true)
    }
}

