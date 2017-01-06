//
//  BasketViewController.swift
//  Mandarin
//
//  Created by Oleg on 12/8/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import RealmSwift

class BasketViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var buttonDeleteAll: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var productsInBasket: Results<ProductsForRealm>!
    
    override func viewDidLoad() {
        let realm = try! Realm()
        productsInBasket = realm.objects(ProductsForRealm.self)
        
       // buttonDeleteAll.layer.borderColor = UIColor.red.cgColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsInBasket.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BasketTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BasketTableViewCell
        
        let productDetails = productsInBasket[indexPath.row]
        Dispatch.mainQueue.async { _ in
            guard let imageData: Data = try? Data(contentsOf: URL(string: productDetails.icon!)!) else { return }
            cell.thubnailImageView?.image = UIImage(data: imageData)
        }
        
        cell.nameLabel?.text = productDetails.name
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! productsInBasket.realm!.write {
                let product = self.productsInBasket[indexPath.row]
                self.productsInBasket.realm!.delete(product)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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

class BasketTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var thubnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        thubnailImageView?.layer.cornerRadius = 30
        thubnailImageView?.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
