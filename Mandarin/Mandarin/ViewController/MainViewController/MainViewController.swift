//
//  MainViewController.swift
//  Mandarin
//
//  Created by Yuriy on 11/29/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, SegmentedControlDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var segmentControl: SegmentControl?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentControl?.delegate = self
        segmentControl?.layer.cornerRadius = 5.0
        segmentControl?.layer.borderColor = Color.mandarin.cgColor
        segmentControl?.layer.borderWidth = 1.0
        segmentControl?.layer.masksToBounds = true
        segmentControl?.selectedSegment = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        UserRequest.getAllCategories(param as [String : AnyObject], completion: {[weak self] json in
            json.forEach { _, json in
                print (">>self - \(json["name"])<<")
                let id = json["id"].string ?? ""
                let description = json["description"].string ?? ""
                let proteins = json["proteins"].string ?? ""
                let calories = json["calories"].string ?? ""
                let zhiry = json["zhiry"].string ?? ""
                let favorite = json["favorite"].string ?? ""
                let category_id = json["category_id"].string ?? ""
                let brand = json["brand"].string ?? ""
                let price_sale = json["price_sale"].string ?? ""
                let weight = json["weight"].string ?? ""
                let status = json["status"].string ?? ""
                let expire_date = json["expire_date"].string ?? ""
                let price = json["proteins"].string ?? ""
                let created_at = json["created_at"].string ?? ""
                let icon = json["icon"].string ?? ""
                let category_name = json["category_name"].string ?? ""
                let name = json["name"].string ?? ""
                let uglevody = json["uglevody"].string ?? ""
                
                let product = Product(id: id, descriptionm: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody)
                self?.internalProducts.append(product)
            }
            self?._products = (self?.internalProducts)!
            self?.tableView.reloadData()
        })
    }
    
    //MARK: SegmentedControlDelegate
    
    func segmentedControl(_ control: SegmentControl, didSelectSegment segment: Int) {
//        guard let controller = viewController(SegmentTab(rawValue: segment)!) else { return }
//        selectedControl?(controller)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _products.count
        
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MainTableViewCell
        
        let productDetails = _products[(indexPath as NSIndexPath).row]
        cell.thubnailImageView?.image = UIImage(named: productDetails.icon)
        cell.nameLabel?.text = productDetails.name
        
        return cell
    }
    
    override func searchTextChanged(sender: UITextField) {
        super.searchTextChanged(sender: sender)
        tableView.reloadData()
    }
    
    @IBAction func menuClick(_ sender: AnyObject) {
        guard let containerViewController = self.parent as? ContainerViewController else { return }
        containerViewController.showMenu(!containerViewController.showingMenu, animated: true)
    }
}
