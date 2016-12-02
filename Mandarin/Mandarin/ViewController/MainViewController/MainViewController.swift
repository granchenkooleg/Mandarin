//
//  MainViewController.swift
//  Mandarin
//
//  Created by Yuriy on 11/29/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SegmentedControlDelegate {
    
    @IBOutlet weak var segmentControl: SegmentControl?
    
    fileprivate var internalProducts: [Products] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentControl?.delegate = self
        segmentControl?.layer.cornerRadius = 5.0
        segmentControl?.layer.borderColor = Color.mandarin.cgColor
        segmentControl?.layer.borderWidth = 1.0
        segmentControl?.layer.masksToBounds = true
        segmentControl?.selectedSegment = 0
        
        for dictionary in Feeds.products {
            let name  =   dictionary["name"] as? String ?? ""
            let capacity = dictionary ["capacity"] as? Int ?? 0
            let photo = dictionary["photo"] as? String ?? ""
            let description = dictionary["description"] as? String ?? ""
            let price = dictionary["price"] as? Int ?? 0
            let manufacturer  =   dictionary["manufacturer"] as? String ?? ""
            let calories = dictionary["ccalories"] as? Int ?? 0
            let proteins = dictionary["proteins"] as? Int ?? 0
            let fats = dictionary["fats"] as? Int ?? 0
            let carbohydrates = dictionary["carbohydrates"] as? Int ?? 0
            let specialPrice = dictionary["specialPrice"] as? Int ?? 0
            let weightOfgoods = dictionary["weightOfgoods"] as? Int ?? 0
            
            let product = Products(price: price, name: name, photo: photo, description: description, manufacturer: manufacturer, capacity: capacity,  calories: calories, proteins: proteins, fats: fats, carbohydrates: carbohydrates, specialPrice: specialPrice, weightOfgoods: weightOfgoods)
            internalProducts.append(product)
            
        }
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
        return internalProducts.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MainTableViewCell
        
        let productDetails = internalProducts[(indexPath as NSIndexPath).row]
        cell.thubnailImageView?.image = UIImage(named: productDetails.photo)
        cell.nameLabel?.text = productDetails.name
        
        return cell
    }
}
