//
//  FavoriteProductsViewController.swift
//  Mandarin
//
//  Created by Yuriy on 1/3/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import UIKit

class FavoriteProductsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellIdentifier = "CategoryTableViewCell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CategoryTableViewCell
//        
//        let productDetails = _products[indexPath.row]
//        Dispatch.mainQueue.async { _ in
//            guard let imageData: Data = try? Data(contentsOf: URL(string: productDetails.icon)!) else { return }
//            cell.thubnailImageView?.image = UIImage(data: imageData)
//        }
//        
//        cell.nameLabel?.text = productDetails.name
//        
        return UITableViewCell()
    }

}
