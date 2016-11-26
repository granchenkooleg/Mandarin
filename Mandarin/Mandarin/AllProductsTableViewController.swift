//
//  AllProductsTableViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/23/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class AllProductsTableViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var products: [[String:Any]] = [
        [
            "name": "Крупы",
            "capacity": 500,
            "photo": "IconMandarin-76",
            "description": "Йогурт Активна с черносливом"
        ],
        [
            "name": "Молочные изделия",
            "capacity": 250,
            "photo": "Icon-76",
            "description": "Йогурт Активна с черносливом"
        ],
        
        [
            "name": "Консервация и соления",
            "capacity": 1000,
            "photo": "IconMandarin-76",
            "description": "Йогурт Активна с черносливом",
            ]
    ]
    
    fileprivate var internalProducts: [Products] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for dictionary in products {
            let name  =   dictionary["name"] as? String ?? ""
            let capacity = dictionary ["capacity"] as? Int ?? 0
            let photo = dictionary["photo"] as? String ?? ""
            let description = dictionary["description"] as? String ?? ""
            let product = Products(name: name, capacity: capacity, photo: photo, description: description, remaindMe: false)
            internalProducts.append(product)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = self.internalProducts[(indexPath as NSIndexPath).row]
        
        //create alert controller
        
        let actionMenu = UIAlertController(title: "День рождения", message: "Через: 7 дней", preferredStyle: .actionSheet)
        
        //create actions for controller
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        actionMenu.addAction(cancelAction)
        
        let callActionHandler = {(action: UIAlertAction!) -> Void in
            let warningMessage = UIAlertController(title: "Сервис не доступен", message: "Попробуйте позже!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
            warningMessage.addAction(okAction)
            
            //to reflect the controller
            
            self.present(warningMessage, animated: true, completion: nil)
        }
        
        let callAction = UIAlertAction(title: "Позвонить", style: .default, handler: callActionHandler)
        actionMenu.addAction(callAction)
        
        let sendCongratulation = UIAlertAction(title: "Отправить открытку", style: .default, handler: {[weak self] _ in
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as? DetailsViewController {
                detailVC.productsImage = product.photo
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
            })
        actionMenu.addAction(sendCongratulation)
        
        let toRemindInThatDay = UIAlertAction(title: "Напоминание в день события!", style: .default, handler: {(action: UIAlertAction!) -> Void in
            // add and remove check for cell
            //let cell = tableView.cellForRow(at: indexPath)
            //product.remaindMe = true
            //cell?.accessoryView?.isHidden = !product.remaindMe
        })
        
        
        let toRemoveRemindInThatDay = UIAlertAction(title: "Удалить напоминание!", style: .default, handler: {(action: UIAlertAction!) -> Void in
            // add and remove check for cell
            //let cell = tableView.cellForRow(at: indexPath)
            //product.remaindMe = false
            //cell?.accessoryView?.isHidden = !product.remaindMe
            
        })
        
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryView?.isHidden == false {
            actionMenu.addAction(toRemoveRemindInThatDay)
        } else {
            actionMenu.addAction(toRemindInThatDay)
        }
        
        //to reflect the controller
        
        self.present(actionMenu, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        
        return internalProducts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AllProductsTableViewCell
        
        // Configure the cell...
        
        let productDetails = internalProducts[(indexPath as NSIndexPath).row]
        cell.thubnailImageView?.image = UIImage(named: productDetails.photo)
        cell.nameLabel?.text = productDetails.name
        cell.capacityLabel?.text = "capacity:" + String(productDetails.capacity)
        cell.locationLabel?.text = productDetails.description
        
        return cell
    }
    
    //remove rows
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.internalProducts.remove(at: (indexPath as NSIndexPath).row)
        
        //        self.tableView.reloadData() // fast removing
        
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}
