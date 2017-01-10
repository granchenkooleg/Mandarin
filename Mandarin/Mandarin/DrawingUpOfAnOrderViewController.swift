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


class DrawingUpOfAnOrderViewController: BaseViewController, UITextFieldDelegate {

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
    
    
    //it spetial for Realm (data extraction) [start
    var adressUserFromRealm : Results<InfoAboutUserForOrder>!
    
    override func viewDidLoad() {
        updateAdressInfo()
        
        nameUserTextField?.text = adressUserFromRealm[0].name
        phoneTextField?.text = adressUserFromRealm[0].phone
        cityTextField?.text = adressUserFromRealm[0].city
        regionTextField?.text = adressUserFromRealm[0].region
        streetTextField?.text = adressUserFromRealm[0].street
        numberHouseTextField?.text = adressUserFromRealm[0].house
        porchTextField?.text = adressUserFromRealm[0].porch
        numberApartmentTextField?.text = adressUserFromRealm[0].apartment
        floorTextField?.text = adressUserFromRealm[0].floor
        commitOfUserTextField?.text = adressUserFromRealm[0].commit
        
        
    }
    
    func updateAdressInfo() {
        let realm = try! Realm()
        adressUserFromRealm = realm.objects(InfoAboutUserForOrder.self)
    }
    
    // end]

    
    // Entring data from textField to Realm
    @IBAction func checkout(_ sender: UIButton)   {
        
        //sender.loading = true
        
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
        
    
        let _ = InfoAboutUserForOrder.setupAllUserInfo(name: nameUser, phone: phone, city: city, region: region ?? "", street: street, house: numberHouse, porch: porch , apartment: apartment , floor: floor ?? "", commit: commit ?? "")

        //MARK: Sender to PaymentVC
        present(UIStoryboard.main["payment"]!, animated: true, completion: nil)
    
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


