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
    
    
    @IBOutlet weak var quantityProductsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var productsInBasket: Results<ProductsForRealm>!
    
    var quantityProductsInCart: Any?
    
    override func viewDidLoad() {
        let realm = try! Realm()
        productsInBasket = realm.objects(ProductsForRealm.self)
        
        //for display quantity products in cart
        quantityProductsInCart = self.productsInBasket.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        //display quantity products in cart
        quantityProductsLabel.text = NSString(format:"%d", quantityProductsInCart as! CVarArg) as String
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
    
    // button red color
    @IBAction func deleteAllButton(_ sender: AnyObject) {
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Удалить корзину?", message: "Вы на самом деле собираетесь удалить все продукты из корзины?", preferredStyle: .alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Нет", style: .cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Удалить", style: .destructive) { action -> Void in
            //Do some other stuff
            ProductsForRealm.deleteAllProducts()
            try! self.productsInBasket.realm!.write {
                let product = self.productsInBasket
                self.productsInBasket.realm!.delete(product!)
                self.tableView.reloadData()
            }
        }
        actionSheetController.addAction(nextAction)
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
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
