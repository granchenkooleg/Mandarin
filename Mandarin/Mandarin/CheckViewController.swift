//
//  CheckViewController.swift
//  Mandarin
//
//  Created by Oleg on 12/8/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import RealmSwift

class CheckViewController: BaseViewController {
    
    @IBOutlet weak var numberOrderLabel: UILabel!
    @IBOutlet weak var dateOrderLabel: UILabel!
    @IBOutlet weak var nameCustomerLabel: UILabel!
    @IBOutlet weak var phoneCustomerLabel: UILabel!
    @IBOutlet weak var adвressCustomerLabel: UILabel!
    @IBOutlet weak var amountMoneyOfOrderLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    
    //it spetial for Realm
    var infoOfUser: Results<InfoAboutUserForOrder>!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        infoOfUser = realm.objects(InfoAboutUserForOrder.self)
        
        // Do any additional setup after loading the view.
        nameCustomerLabel.text = infoOfUser[0].name
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showGoodsButton(_ sender: UIButton) {
        
        
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
