//
//  PaymentViewController.swift
//  Mandarin
//
//  Created by Oleg on 12/8/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class PaymentViewController: BasketViewController {
    
    @IBOutlet weak var needChangeButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var totalPriceForPaymentVCLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            textField.placeholder = "123"
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
    }
    
    // MARK: Sender to CheckVC
    @IBAction func CheckClick(_ sender: Button) {
        
        //sender.loading = true
        
        let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                 "user_id" :  Int((User.currentUser?.id)!),
                                 "product_id[]" : 7,
                                 "order_id" :  /*тут должно быть adressUserFromRealm[0].idOrder*/"2"] as [String : Any]
        
        
        UserRequest.addOrderToServer(param as [String : AnyObject], completion: {[weak self] success in
            if success == true {
                self?.present(UIStoryboard.main["checkVC"]!, animated: true, completion: nil)
            }
            //sender.loading = false
            })
    }
    
}
