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
    
    var internalProductsForListOfWeightVC = [Product]()
    var _productsList = [Product]()
    
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
                self?.internalProductsForListOfWeightVC.append(list)
                
            }
            self?._productsList = (self?.internalProductsForListOfWeightVC)!
            self?.tableView.reloadData()
            })
    }
    
    //MARK: - Transparent Table View With a Background Image
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "SearchHello.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        // no lines where there aren't cells
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // center and scale background image
        imageView.contentMode = .scaleAspectFit
        
        // Set the background color to match better
        //        tableView.backgroundColor = UIColor.lightGray
        
        // blur it
        //        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        //        let blurView = UIVisualEffectView(effect: blurEffect)
        //        blurView.frame = imageView.bounds
        //        imageView.addSubview(blurView)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _productsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchViewController"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchTableViewCell
        
        let productDetails = _productsList[indexPath.row]
        Dispatch.mainQueue.async { _ in
            let imageData: Data = try! Data(contentsOf: URL(string: productDetails.icon)!)
            cell.thubnailImageView?.image = UIImage(data: imageData)
        }
        
        cell.nameLabel?.text = productDetails.name
        
        return cell
    }
    
    //Making UITableView Cells Transparent
    /* Next we’ll deal with the table view cells hiding the backgound image. It might seem reasonable work in tableView: cellForRowAtIndexPath: to do that but that function can get pretty cluttered. Instead there’s a UITableViewDelegate function just for making tweaks to the cell’s appearance just before it gets displayed */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // translucent cell backgrounds so we can see the image but still easily read the contents
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1) /*UIColor.clear*/
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

class SearchTableViewCell: UITableViewCell {
    
    
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
