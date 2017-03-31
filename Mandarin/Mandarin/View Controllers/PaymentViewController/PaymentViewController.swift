//
//  PaymentViewController.swift
//  Bezpaketov
//
//  Created by Oleg on 12/8/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import SwiftyJSON
import MessageUI

class PaymentViewController: BasketViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var needChangeButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var totalPriceForPaymentVCLabel: UILabel!
    @IBOutlet weak var customTextLabel: UILabel!
    
    // For request deliveryTime
    var deliveryTime: String?
    
    // Navigation DrawingUpOfVC
    var idOrderPayment: String?
    var phoneUserPayment: String?
    var nameUserPayment: String?
    var cityPayment: String?
    var regionPayment: String?
    var streetPayment: String?
    var numberHousePayment: String?
    var porchPayment: String?
    var apartmentPayment: String?
    var floorPayment: String?
    var commitPayment: String?
    var textUserInFildAlert: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Request for delivery time of check
        let param_2: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        UserRequest.deliveryTime(param_2 as [String : AnyObject], completion: {[weak self] json in
            json.forEach { _, json in
                
                self?.deliveryTime = json["value"].string ?? ""
            }
        })
        
        // Do any additional setup after loading the view.
        self.totalPriceForPaymentVCLabel?.text = (totalPriceInCart() + " грн.")
        
        
        // Set continueButton hidden at start
        continueButton.isHidden = true
    }
    
    
    @IBAction func needChangeButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Сдача!", message: "Пожалуйста, впишите вашу купюру", preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(title: "Отменить", style: .cancel) { (action:UIAlertAction) in
            // This is called when the user presses the cancel button.
            print("You've pressed the cancel button");
        }
        
        let actionOk = UIAlertAction(title: "Ок", style: .default) { (action:UIAlertAction) in
            // This is called when the user presses the login button.
            let textUser = alertController.textFields![0] as UITextField
            guard let textUserInFildAlert = textUser.text else { return }
            self.textUserInFildAlert = textUserInFildAlert
            print("The user entered:%@ ",textUserInFildAlert);
        }
        
        alertController.addTextField { (textField) -> Void in
            // Configure the attributes of the first text box.
            textField.placeholder = "100"
        }
        
        // Add the buttons
        alertController.addAction(actionCancel)
        alertController.addAction(actionOk)
        
        // Present the alert controller
        self.present(alertController, animated: true, completion:nil)
        
        continueButton.isHidden = false
        noButton.isHidden = true
        needChangeButton.isHidden = true
    }
    
    // Here is the action when you press noButton which is visible
    @IBAction func noButton(_ sender: UIButton) {
        continueButton.isHidden = false
        noButton.isHidden = true
        needChangeButton.isHidden = true
        
    }
    
    // MARK: Sender to CheckVC
    @IBAction func CheckClick(_ sender: Button) {
        
        // Check Internet connection
        guard isNetworkReachable() == true  else {
            Dispatch.mainQueue.async {
                let alert = UIAlertController(title: "Нет Интернет Соединения", message: "Убедитесь, что Ваш девайс подключен к сети интернет", preferredStyle: .alert)
                let OkAction = UIAlertAction(title: "Ok", style: .default) {action in
                    
                }
                alert.addAction(OkAction)
                alert.show()
            }
            return
        }
        
        // For send mail to magazin
        let _name = " Имя заказчика: " + (nameUserPayment ?? "")
        let _phone = " | Телефон: " + (phoneUserPayment ?? "")
        let _city = " | Город: " + (cityPayment ?? "")
        let _region = " | Регион: " + (regionPayment ?? "")
        let _street = " | Улица: " + streetPayment!
        let _numberHouse = " | Номер дома :" + (numberHousePayment ?? "")
        let _porch = " | Подъезд: " + (porchPayment ?? "")
        let _appartment = " | Квартира: " + (apartmentPayment ?? "")
        let _floor = " | Этаж: " + (floorPayment ?? "")
        let _commit = " | Комментарий: " + (commitPayment ?? "")
        let _bond = " | Сумма на руках: " + (textUserInFildAlert ?? "")
        let _totalPriceinCart = " | Общая сума заказа: " + (totalPriceInCart() + " грн.")
        var body =  (_name + _phone  + _city  + _region + _street + _numberHouse + _porch + _appartment + _floor + _commit + _bond + _totalPriceinCart)
        
        
        // Doing it for product_id in Alamofire request(param)
        var list: [JSON] = []
        // For body
        var listSpeciallyForMail: [String] = []
        
        for i in productsInBasket {
            var count = 0
            // Convert type String to Int
            let q: Int = Int(i.quantity)!
            for _ in 1...q {
                list.append(JSON(i.id))
                
                // For listSpeciallyForMail
                count += 1
            }
            listSpeciallyForMail.append(i.id + " x \(count)")
        }
        
        // Add yet to body listSpeciallyForMail
        body += " | Продукты: " + "\(listSpeciallyForMail)"
        
        let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                 "user_id" :  User.currentUser?.idUser as Any,
                                 "user_phone": phoneUserPayment as Any,
                                 "product_id": list,
                                 "order_id" : self.idOrderPayment as Any,
                                 "fields": body ] as [String : Any]
        
        UserRequest.addOrderToServer(param as [String : AnyObject], completion: { success in
            if success == true {
                guard let checkVC = UIStoryboard.main["checkVC"] as? CheckViewController else { return }
                checkVC.valueDeliveryTime = self.deliveryTime ?? ""
                checkVC.addToContainer()
                
            } else {
                let alertController = UIAlertController(title: "Введите правильно номер телефона или ваш пакет пуст", message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                    // ...
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
            }
        })
    }
}
