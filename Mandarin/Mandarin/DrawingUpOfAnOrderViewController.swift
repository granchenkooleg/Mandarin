//
//  DrawingUpOfAnOrderViewController.swift
//  Mandarin
//
//  Created by Oleg on 12/8/16.
//  Copyright © 2016 Oleg. All rights reserved.
//
import Foundation
import UIKit
import RealmSwift
import MessageUI


class DrawingUpOfAnOrderViewController: BaseViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var nameUserTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var numberHouseTextField: UITextField!
    @IBOutlet weak var porchTextField: UITextField!
    @IBOutlet weak var numberApartmentTextField: UITextField!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var commitOfUserTextField: UITextField!
    
    
    // It spetial for Realm (data extraction) [start
    var adressUserFromRealm : Results<InfoAboutUserForOrder>!
    
    override func viewDidLoad() {
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
            commitOfUserTextField?.text = adressUserFromRealm.last?.commit
        }
    }
    
    func updateAdressInfo() {
        let realm = try! Realm()
        adressUserFromRealm = realm.objects(InfoAboutUserForOrder.self)
    }
    
    // end]
    
    
    // Entring data from textField to Realm
    @IBAction func checkout(_ sender: UIButton)   {
        
        //sender.loading = true
        
        //let idOrder = "1"
        
        guard let nameUser = nameUserTextField.text, nameUser.isEmpty == false else {
            
            let alertController = UIAlertController.alert("Введите вашe имя!".ls)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            
            //sender.loading = false
            return
        }
        
        guard let phone = phoneTextField.text, phone.isEmpty == false else {
            
            let alertController = UIAlertController.alert("Введите ваш номер телефона!".ls)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            
            //sender.loading = false
            return
        }
        
        guard let city = cityTextField.text, city.isEmpty == false else {
            
            let alertController = UIAlertController.alert("Введите название вашего города!".ls)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            
            //sender.loading = false
            return
        }
        
        let region = regionTextField.text
        
        guard let street = streetTextField.text, street.isEmpty == false else {
            
            let alertController = UIAlertController.alert("Введите название вашей улицы!".ls)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            
            //sender.loading = false
            return
        }
        
        guard let numberHouse = numberHouseTextField.text, numberHouse.isEmpty == false else {
            
            let alertController = UIAlertController.alert("Введите  номер вашего дома!".ls)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            
            //sender.loading = false
            return
        }
        
        guard let porch = porchTextField.text, porch.isEmpty == false else {
            
            let alertController = UIAlertController.alert("Введите номер вашего подъезда!".ls)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            
            //sender.loading = false
            return
        }
        
        guard let apartment = numberApartmentTextField.text, apartment.isEmpty == false else {
            
            let alertController = UIAlertController.alert("Введите номер вышей квартиры!".ls)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            
            //sender.loading = false
            return
        }
        
        
        let floor = floorTextField.text
        let commit = commitOfUserTextField.text
        
        
        let _ = InfoAboutUserForOrder.setupAllUserInfo(/*idOrder: idOrder ,*/ name: nameUser, phone: phone, city: city, region: region ?? "", street: street, house: numberHouse, porch: porch , apartment: apartment , floor: floor ?? "", commit: commit ?? "")
        
        //MARK: Sender to PaymentVC
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
        containerViewController.addController(UIStoryboard.main["payment"]!)
        let _name = "NameUser: " + nameUser + "\n"
        let _phone = "Phone: " + phone + "\n"
        let _city = "City: " + city + "\n"
        let _region = "Region: " + (region ?? "") + "\n"
        let _street = "Street" + street + "\n"
        let _numberHouse = "NumberHouse :" + numberHouse + "\n"
        let _porch = "Porch: " + porch  + "\n"
        let _appartment = "Apartment: " + apartment + "\n"
        let _floor = "Floor: " + (floor ?? "") + "\n"
        let _commit = "Commit: " + (commit ?? "")
        sendMessage(body: _name + _phone  + _city  + _region + _street + _numberHouse + _porch + _appartment + _floor + _commit, recipients: ["oleg_granchenko@mail.ru"])
    }
    
    func sendMessage(body: String, recipients: [String]) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(recipients)
            mailComposeVC.setMessageBody(body, isHTML: false)
            UINavigationController.main.present(mailComposeVC, animated: true, completion: nil)
        }
    }
    
    //MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


