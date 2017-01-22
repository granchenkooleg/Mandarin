//
//  CheckViewController.swift
//  Mandarin
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
        
        let realm = try! Realm()
        infoOfUser = realm.objects(InfoAboutUserForOrder.self)
        
        // Do any additional setup after loading the view.
        //dateOrderLabel.text
        numberOrderLabel.text = infoOfUser.last?.idOrder
        nameCustomerLabel.text = infoOfUser.last?.name
        phoneCustomerLabel.text = infoOfUser.last?.phone
        
        adressCustomerLabel.text = "\(infoOfUser.last?.city ?? "")," as String + "\(infoOfUser.last?.street ?? "")," as String + "\(infoOfUser.last?.house ?? "")," as String + "\(infoOfUser.last?.apartment ?? "")," as String
        //adressCustomerLabel.text = infoOfUser.last?.street ?? ""
//        (infoOfUser.last?.house) ?? "", (infoOfUser.last?.apartment) ?? ""
        amountMoneyOfOrderLabel.text = (totalPriceInCart() + " грн.")
        dateOrderLabel.text = dateFormatter()
    }
    
    
    // MARK: Sender to BasketVC
    @IBAction func showGoodsButton(_ sender: UIButton) {
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
        containerViewController.addController(UIStoryboard.main["basketAfterpayment"]!)
    }
}

