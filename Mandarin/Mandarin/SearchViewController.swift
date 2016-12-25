//
//  SearchViewController.swift
//  Mandarin
//
//  Created by Oleg on 12/18/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        UserRequest.listAllProducts(param as [String : AnyObject], completion: {[weak self] json in
            json.forEach { _, json in
                print (">>self - \(json["name"])<<")
                let id = json["id"].string ?? ""
                let created_at = json["created_at"].string ?? ""
                let icon = json["icon"].string ?? ""
                let name = json["name"].string ?? ""
                let category_id = json["category_id"].string ?? ""
                let weight = json["weight"].string ?? ""
                let description = json["description"].string ?? ""
                let brand = json["brand"].string ?? ""
                let calories = json["calories"].string ?? ""
                let proteins = json["proteins"].string ?? ""
                let zhiry = json["zhiry"].string ?? ""
                let uglevody = json["uglevody"].string ?? ""
                let price = json["price"].string ?? ""
                let favorite = json["favorite"].string ?? ""
                let status = json["status"].string ?? ""
                let expire_date = json["expire_date"].string ?? ""
                let category_name = json["category_name"].string ?? ""
                let price_sale = json["price_sale"].string ?? ""
                
                
                let list = Product(id: id, description: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody, units: "")
                self?.internalProducts.append(list)
                
            }
            self?._products = (self?.internalProducts)!
            self?.tableView.reloadData()
            })
    }
    
    //MARK: - Transparent Table View With a Background Image
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        // Add a background view to the table view
//        let backgroundImage = UIImage(named: "SearchHello.png")
//        let imageView = UIImageView(image: backgroundImage)
//        self.tableView.backgroundView = imageView
//        
//        // no lines where there aren't cells
//        tableView.tableFooterView = UIView(frame: CGRect.zero)
//        
//        // center and scale background image
//        imageView.contentMode = .scaleAspectFill
//        
//        // Set the background color to match better
//        //        tableView.backgroundColor = UIColor.lightGray
//        
//        // blur it
//        //                let blurEffect = UIBlurEffect(style: .extraLight)
//        //                let blurView = UIVisualEffectView(effect: blurEffect)
//        //                blurView.frame = imageView.bounds
//        //                imageView.addSubview(blurView)
//    }
    
    override func searchTextChanged(sender: UITextField) {
        super.searchTextChanged(sender: sender)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchViewController"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchTableViewCell
        
        let productDetails = _products[indexPath.row]
        Dispatch.mainQueue.async { _ in
            guard let imageData: Data = try? Data(contentsOf: URL(string: productDetails.icon)!) else { return }
            cell.thubnailImageView?.image = UIImage(data: imageData)
        }
        
        cell.nameLabel?.text = productDetails.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
    }
}

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thubnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thubnailImageView?.layer.cornerRadius = 30
        thubnailImageView?.layer.masksToBounds = true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
