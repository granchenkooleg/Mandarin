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
        dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm:ss"
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
        numberOrderLabel.text = infoOfUser[0].idOrder
        nameCustomerLabel.text = infoOfUser[0].name
        phoneCustomerLabel.text = infoOfUser[0].phone
        adressCustomerLabel.text = infoOfUser[0].city! + "/" + infoOfUser[0].street! + "/" + infoOfUser[0].house! + "/" + infoOfUser[0].apartment!
        amountMoneyOfOrderLabel.text = (totalPriceInCart() + " грн.")
        dateOrderLabel.text = dateFormatter()
    }
    
    
    // MARK: Sender to BasketVC
    @IBAction func showGoodsButton(_ sender: UIButton) {
        present(UIStoryboard.main["basketAfterpayment"]!, animated: true, completion: nil)
    }
    
}

