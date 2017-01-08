//
//  DrawingUpOfAnOrderViewController.swift
//  Mandarin
//
//  Created by Oleg on 12/8/16.
//  Copyright © 2016 Oleg. All rights reserved.
//
import Foundation
import UIKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkout(_ sender: UIButton) {
        
        //sender.loading = true
        
        guard let nameUser = nameUserTextField.text,
            nameUser.isEmpty == false else {
            UIAlertController.alert("Введите ваше имя!".ls).show()
            //sender.loading = false
            return
        }
        
        guard let phone = phoneTextField.text, phone.isEmpty == false else {
            UIAlertController.alert("Введите ваш номер телефона!".ls).show()
            //sender.loading = false
            return
        }
        
        guard let city = cityTextField.text, city.isEmpty == false else {
            UIAlertController.alert("Введите ваш город!".ls).show()
            //sender.loading = false
            return
        }
        
        let region = regionTextField.text
        
        guard let street = streetTextField.text, street.isEmpty == false else {
            UIAlertController.alert("Введите название вашей улицы!".ls).show()
            //sender.loading = false
            return
        }
        
        guard let numberHouse = numberHouseTextField.text, numberHouse.isEmpty == false else {
            UIAlertController.alert("Введите номер вашего дома!".ls).show()
            //sender.loading = false
            return
        }
        
        guard let porch = porchTextField.text, porch.isEmpty == false else {
            UIAlertController.alert("Введите номер вашего подъезда!".ls).show()
            //sender.loading = false
            return
        }
        
        guard let apartment = numberApartmentTextField.text, apartment.isEmpty == false else {
            UIAlertController.alert("Введите номер вашей квартиры!".ls).show()
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
