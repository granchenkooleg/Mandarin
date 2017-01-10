//
//  PaymentViewController.swift
//  Mandarin
//
//  Created by Oleg on 12/8/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class PaymentViewController: BasketViewController {
    
    @IBOutlet weak var totalPriceForPaymentVCLabel: UILabel!

     override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        totalPriceForPaymentVCLabel?.text = (totalPriceInCart() + " грн.,")
    }

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Sender to CheckVC
    @IBAction func CheckClick(_ sender: UIButton) {
        present(UIStoryboard.main["checkVC"]!, animated: true, completion: nil)
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
