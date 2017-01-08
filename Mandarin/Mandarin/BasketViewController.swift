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
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //it spetial for Realm
    var productsInBasket: Results<ProductsForRealm>!
    
    override func viewDidLoad() {
        updateProductInfo()
    }
    
    func updateProductInfo() {
        let realm = try! Realm()
        productsInBasket = realm.objects(ProductsForRealm.self)
        totalPriceLabel?.text = (totalPriceInCart() + " грн.")
        updateProductInBasket()
    }
    
    //for total price
    func totalPriceInCart() -> String {
        var totalPrice: Float = 0
        for product in  productsInBasket {
            totalPrice += Float(product.price!)! * Float(product.quantity)!
        }
        
        return String(totalPrice)
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
            guard let imageData: Data = try? Data(contentsOf: URL(string: productDetails.icon ?? "")!) else { return }
            cell.thubnailImageView?.image = UIImage(data: imageData)
        }
        
        cell.productID = productDetails.id
        cell.quantity = Int(productDetails.quantity) ?? 0
        cell.nameLabel?.text = productDetails.name
        cell.weightLabel?.text = productDetails.weight! + productDetails.units!
        cell.priceLabel?.text = (productDetails.price ?? "") + " грн."
        cell.quantityLabel.text = productDetails.quantity
        cell.completionBlock = {[weak self] in
            self?.updateProductInfo()
        }
        
        return cell
    }
    
    //it for selete rows [start
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
            updateProductInfo()
        }
    }
    //end]
    
    // button delete red color
    @IBAction func deleteAllButton(_ sender: AnyObject) {
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Удалить корзину?", message: "Вы на самом деле собираетесь удалить все продукты из корзины?", preferredStyle: .alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Нет", style: .cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Удалить", style: .destructive) {[weak self] action -> Void in
            //Do some other stuff
            ProductsForRealm.deleteAllProducts()
 
            self?.tableView.reloadData()
            self?.updateProductInfo()
        }
        actionSheetController.addAction(nextAction)
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
       
        
    }
    
    //MARK: Sender to DrawingUpOfAnOrderVC
    @IBAction func DrawingUpOrderClick(_ sender: UIButton) {
        present(UIStoryboard.main["drawingUpOrder"]!, animated: true, completion: nil)
    }
    
}

class BasketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var thubnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    var productID: String = ""
    var quantity: Int = 1
    var completionBlock: Block?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        thubnailImageView?.layer.cornerRadius = 30
        thubnailImageView?.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addProduct(sender: AnyObject) {
        quantity += 1
        quantityLabel.text = "\(quantity) шт."
        updateProduct()
        completionBlock?()
    }
    
    @IBAction func subProduct(sender: AnyObject) {
        guard quantity > 1 else { return }
        quantity -= 1
        quantityLabel.text = "\(quantity) шт."
        updateProduct()
        completionBlock?()
    }
    
    func updateProduct () {
        let realm = try! Realm()
        let product = realm.objects(ProductsForRealm.self).filter("id  == [c] %@", productID).first
        try! realm.write {
            product!.quantity = "\(quantity)"
        }
    }
}
