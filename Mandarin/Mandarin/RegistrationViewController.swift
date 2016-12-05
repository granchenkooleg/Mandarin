//
//  RegistrationViewController.swift
//  Mandarin
//
//  Created by Oleg on 12/5/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class RegistrationViewController: LoginViewController {
    
    //MARK: Property
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var telephoneLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var repeatPasswordLabel: UITextField!
    @IBOutlet weak var birthdayLabel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
