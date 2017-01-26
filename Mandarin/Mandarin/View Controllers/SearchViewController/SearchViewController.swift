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
    
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        products = Product().allProducts()
        tableView.reloadData()
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
    
    //for search
    override func searchTextChanged(sender: UITextField) {
        super.searchTextChanged(sender: sender)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchViewController"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchTableViewCell
        
        let productDetails = products[indexPath.row]
        Dispatch.mainQueue.async { _ in
            cell.thubnailImageView?.image = UIImage(data: productDetails.image ?? Data())
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
