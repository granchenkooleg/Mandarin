//
//  DrawingUpOfAnOrderViewController.swift
//  Bezpaketov
//
//  Created by Oleg on 12/8/16.
//  Copyright © 2016 Oleg. All rights reserved.
//
import Foundation
import UIKit
import RealmSwift
/*import MessageUI*/


class DrawingUpOfAnOrderViewController: BaseViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var nameUserTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var numberHouseTextField: UITextField!
    @IBOutlet weak var porchTextField: UITextField!
    @IBOutlet weak var numberApartmentTextField: UITextField!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var commitOfUserTextView: UITextView!
    
    
    // It spetial for Realm (data extraction) [start
    var adressUserFromRealm : Results<InfoAboutUserForOrder>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TextViewCommit for order
        commitOfUserTextView.text = "Комментарий к заказу"
        commitOfUserTextView.textColor = UIColor.lightGray
        
        updateAdressInfo()
        
        // If table InfoAboutUserForOrder isEmpty, we will not come in here
        if (adressUserFromRealm.isEmpty == false)  {
            // Get last data because user can change last self data
            nameUserTextField?.text = adressUserFromRealm.last?.name
            phoneTextField?.text = adressUserFromRealm.last?.phone
            cityTextField?.text = adressUserFromRealm.last?.city
            regionTextField?.text = adressUserFromRealm.last?.region
            streetTextField?.text = adressUserFromRealm.last?.street
            numberHouseTextField?.text = adressUserFromRealm.last?.house
            porchTextField?.text = adressUserFromRealm.last?.porch
            numberApartmentTextField?.text = adressUserFromRealm.last?.apartment
            floorTextField?.text = adressUserFromRealm.last?.floor
        }
    }
    
    // TextViewCommit for order
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    // TextViewCommit for order
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Комментарий к заказу"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    func updateAdressInfo() {
        let realm = try! Realm()
        adressUserFromRealm = realm.objects(InfoAboutUserForOrder.self)
    }
    // end]
    
    // Entring data from textField to Realm
    @IBAction func checkout(_ sender: UIButton)   {
        
        guard let nameUser = nameUserTextField.text, nameUser.isEmpty == false else {
            
            let alertController = UIAlertController.alert("Введите Вашe имя".ls)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            
            return
        }
        
        guard let phone = phoneTextField.text, phone.isEmpty == false else {
            
            let alertController = UIAlertController.alert("Введите Ваш номер телефона".ls)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            
            return
        }
        
        guard let city = cityTextField.text, city.isEmpty == false else {
            
            let alertController = UIAlertController.alert("Введите название Вашего города".ls)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            
            return
        }
        
        let region = regionTextField.text
        
        guard let street = streetTextField.text, street.isEmpty == false else {
            
            let alertController = UIAlertController.alert("Введите название Вашей улицы".ls)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            
            return
        }
        
        guard let numberHouse = numberHouseTextField.text, numberHouse.isEmpty == false else {
            
            let alertController = UIAlertController.alert("Введите  номер Вашего дома".ls)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            
            return
        }
        
        let porch = porchTextField.text
        let apartment = numberApartmentTextField.text
        let floor = floorTextField.text
        let commit = commitOfUserTextView.text
        
        let _ = InfoAboutUserForOrder.setupAllUserInfo(/*idOrder: idOrder ,*/ name: nameUser, phone: phone, city: city, region: region ?? "", street: street, house: numberHouse, porch: porch ?? "", apartment: apartment ?? "" , floor: floor ?? "", commit: commit ?? "")
        
        //MARK: Sender to PaymentVC
        
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
        
        guard let paymentVC = UIStoryboard.main["payment"] as? PaymentViewController, let last = adressUserFromRealm.last else { return }
        paymentVC.idOrderPayment = last.idOrder
        paymentVC.phoneUserPayment = last.phone
        paymentVC.nameUserPayment = last.name
        paymentVC.cityPayment = last.city
        paymentVC.regionPayment = last.region
        paymentVC.streetPayment = last.street
        paymentVC.numberHousePayment = last.house
        paymentVC.porchPayment = last.porch
        paymentVC.apartmentPayment = last.apartment
        paymentVC.floorPayment = last.floor
        paymentVC.commitPayment = last.commit
        paymentVC.addToContainer()
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return  textField.resignFirstResponder()
    }
    
    override func keyboardAdjustmentConstant(_ adjustment: KeyboardAdjustment, keyboard: Keyboard) -> CGFloat {
        if regionTextField.isFirstResponder ||
            commitOfUserTextView.isFirstResponder ||
            numberApartmentTextField.isFirstResponder ||
            floorTextField.isFirstResponder ||
            numberHouseTextField.isFirstResponder ||
            porchTextField.isFirstResponder {
            return adjustment.defaultConstant + 350
        }
        return 0
    }
    
}


