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
        
        // Checking for next step
        checking()
        
        // Set continueButton hidden at start
        continueButton.isHidden = true
    }
    
    func checking () {
        guard (Double(totalPriceInCart())) ?? 0.0 > 0.0 else {
            // Do any additional setup after loading the view.
            //self.totalPriceForPaymentVCLabel?.text = (totalPriceInCart() + " грн.")
            noButton.isHidden = true
            needChangeButton.isHidden = true
            customTextLabel.isHidden = true
            return
        }
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
        
        //sender.loading = true
        /*guard*/ let idOrPhone  = User.currentUser?.idUser ?? phoneUserPayment /*, let idOrder = idOrder*/ /*else { return }*/
        
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
                                 "user_id" :  idOrPhone as Any,
                                 "product_id": list,
                                 "order_id" : idOrderPayment as Any] as [String : Any]
        
        UserRequest.addOrderToServer(param as [String : AnyObject], completion: {[weak self] success in
            if success == true {
                guard let checkVC = UIStoryboard.main["checkVC"] as? CheckViewController else { return }
                checkVC.valueDeliveryTime = self?.deliveryTime ?? ""
                self?.present(checkVC, animated: true)
                
                //                containerViewController.addController(UIStoryboard.main["checkVC"]!)
            }
            //sender.loading = false
        })
        
        // For send mail to magazin
        let _name = "Имя заказчика: " + (nameUserPayment ?? "") + "\n"
        let _phone = "Телефон: " + (phoneUserPayment ?? "") + "\n"
        let _city = "Город: " + (cityPayment ?? "") + "\n"
        let _region = "Регион: " + (regionPayment ?? "") + "\n"
        let _street = "Улица: " + streetPayment! + "\n"
        let _numberHouse = "Номер дома :" + (numberHousePayment ?? "") + "\n"
        let _porch = "Подъезд: " + (porchPayment ?? "")  + "\n"
        let _appartment = "Квартира: " + (apartmentPayment ?? "") + "\n"
        let _floor = "Этаж: " + (floorPayment ?? "") + "\n"
        let _commit = "Комментарий: " + (commitPayment ?? "") + "\n"
        let _bond = "Сумма на руках: " + (textUserInFildAlert ?? "")
        sendMessage(body: _name + _phone  + _city  + _region + _street + _numberHouse + _porch + _appartment + _floor + _commit + _bond, recipients: ["oleg_granchenko@mail.ru"])
    }
    
    // For mail
    func sendMessage(body: String, recipients: [String]) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(recipients)
            mailComposeVC.setMessageBody(body, isHTML: false)
            UINavigationController.main.present(mailComposeVC, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Не возможно отправить Email", message: "Ваш девайс не может отправить e-mail. Пожалуйста проверьте ваши настройки конфигурации и пробуйте снова.", preferredStyle: .alert)
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
