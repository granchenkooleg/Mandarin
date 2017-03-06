//
//  PaymentViewController.swift
//  Mandarin
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
                //                let id = json["id"].string ?? ""
                //                let name = json["name"].string ?? ""
                //                let alias = json["alias"].string ?? ""
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
        let body =  (_name + _phone  + _city  + _region + _street + _numberHouse + _porch + _appartment + _floor + _commit + _bond)
        
        
        //        let idOfUser = (((User.currentUser?.idUser)?.isEmpty)! == false)  ? ((User.currentUser?.idUser)! + body) : (User.currentUser?.idUser)
        //        let phoneOfUser = (((User.currentUser?.idUser)?.isEmpty)! != false) ? (phoneUserPayment! + body) : phoneUserPayment
        
        //let idUserInDB  = User.currentUser?.idUser
        
        // Doing it for product_id in Alamofire request(param)
        var list: [JSON] = []
        for i in productsInBasket {
            // Convert type String to Int
            let q: Int = Int(i.quantity)!
            for _ in 1...q {
                list.append(JSON(i.id))
            }
        }
        
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
                
                //                containerViewController.addController(UIStoryboard.main["checkVC"]!)
            } else {
                let alertController = UIAlertController(title: "Введите правильно номер телефона или ваш пакет пуст", message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                    // ...
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
                //self.dismiss(animated: true, completion: nil)
                
            }
            //sender.loading = false
        })
//        ProductsForRealm.deleteAllProducts()
//        updateProductInfo()
    }
    
    // For mail
    //    func sendMessage(body: String, recipients: [String]) {
    //        if MFMailComposeViewController.canSendMail() {
    //            let mailComposeVC = MFMailComposeViewController()
    //            mailComposeVC.mailComposeDelegate = self
    //            mailComposeVC.setToRecipients(recipients)
    //            mailComposeVC.setMessageBody(body, isHTML: false)
    //            present(mailComposeVC, animated: true, completion: nil)
    //        } else {
    //            self.showSendMailErrorAlert()
    //        }
    //    }
    //
    //    func showSendMailErrorAlert() {
    //        let sendMailErrorAlert = UIAlertController(title: "Не возможно отправить Email", message: "Ваш девайс не может отправить e-mail. Пожалуйста проверьте ваши настройки и пробуйте снова.", preferredStyle: .alert)
    //        sendMailErrorAlert.show()
    //    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    //    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    //        //sender.loading = true
    //        /*guard*/ let idUserInDB  = User.currentUser?.idUser   /*, let idOrder = idOrder*/ /*else { return }*/
    //        // Doing it for product_id in Alamofire request(param)
    //        var list: [JSON] = []
    //        for i in productsInBasket {
    //            // Convert type String to Int
    //            let q: Int = Int(i.quantity)!
    //            for _ in 1...q {
    //                list.append(JSON(i.id))
    //            }
    //        }
    //
    //        controller.dismiss(animated: true, completion: { [weak self] in
    //            let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
    //                                     "user_id" :  idUserInDB as Any,
    //                                     "user_phone": self!.phoneUserPayment as Any,
    //                                     "product_id": list,
    //                                     "order_id" : self!.idOrderPayment as Any] as [String : Any]
    //
    //            UserRequest.addOrderToServer(param as [String : AnyObject], completion: { success in
    //                if success == true {
    //                    guard let checkVC = UIStoryboard.main["checkVC"] as? CheckViewController else { return }
    //                    checkVC.valueDeliveryTime = self?.deliveryTime ?? ""
    //                    self?.present(checkVC, animated: true)
    //
    //                    //                containerViewController.addController(UIStoryboard.main["checkVC"]!)
    //                } else {
    //                    let alertController = UIAlertController(title: "Введите коректные данные", message: "", preferredStyle: .alert)
    //                    let OKAction = UIAlertAction(title: "OK", style: .default) { action in
    //                        // ...
    //                    }
    //                    alertController.addAction(OKAction)
    //                    self?.present(alertController, animated: true)
    //                    //self.dismiss(animated: true, completion: nil)
    //                    
    //                }
    //                //sender.loading = false
    //            })
    //        })
    //    }
}
