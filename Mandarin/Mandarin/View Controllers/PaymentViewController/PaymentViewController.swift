//
//  PaymentViewController.swift
//  Mandarin
//
//  Created by Oleg on 12/8/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import SwiftyJSON

class PaymentViewController: BasketViewController {
    
    @IBOutlet weak var needChangeButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var totalPriceForPaymentVCLabel: UILabel!
    
    // For request deliveryTime
    var deliveryTime: String?
    
    // Navigation DrawingUpOfVC
    var idOrder: String?
    var phoneUser: String?
    
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
        totalPriceForPaymentVCLabel?.text = (totalPriceInCart() + " грн.,")
        
        // Set continueButton hidden at start
        continueButton.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            
            print("The user entered:%@ ",textUser.text!);
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
        /*guard*/ let idOrPhone  = User.currentUser?.id ?? phoneUser /*, let idOrder = idOrder*/ /*else { return }*/
        
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
                                 "user_id" :  idOrPhone,
                                 "product_id": list,
                                 "order_id" : idOrder] as [String : Any]
        
        UserRequest.addOrderToServer(param as [String : AnyObject], completion: {[weak self] success in
            if success == true {
                guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
                guard let checkVC = UIStoryboard.main["checkVC"] as? CheckViewController else { return }
                checkVC.valueDeliveryTime = self?.deliveryTime ?? ""
                containerViewController.addController(checkVC)

//                containerViewController.addController(UIStoryboard.main["checkVC"]!)
            }
            //sender.loading = false
            })
    }
    
}
