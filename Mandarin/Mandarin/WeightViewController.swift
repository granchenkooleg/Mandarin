//
//  WeightViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/30/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class WeightViewController: CategoryViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var weightHeaderLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var unitOfWeight: String = ""
    var nameWeightHeaderText: String = ""
    var podCategory_id: String = ""
    var contentWeightProduct = [String]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weightHeaderLabel.text = nameWeightHeaderText
        
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79", "category_id" : "\(podCategory_id)"]
        UserRequest.getWeightCategory(param as [String : AnyObject], completion: {[weak self] json in
            json.forEach { _, json in
                let weight = json["weight"].string ?? ""
                self?.contentWeightProduct.append(weight)
            }
            self?.collectionView.reloadData()
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentWeightProduct.count
    }

  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weigthCell", for: indexPath) as? WeightCollectionViewCell
        cell?.weightUnitsLabelOne.text = "\(contentWeightProduct[indexPath.row]) " + self.unitOfWeight
        
        return cell ?? UICollectionViewCell()
    }
    
    //MARK: Segue
        func tableView(_ collectionView: UICollectionView, didSelectRowAt indexPath: IndexPath) {
        let listOfProductsByWeightViewController = Storyboard.ListOfWeightProducts.instantiate()
        listOfProductsByWeightViewController.nameListsOfProductsHeaderText = _products[indexPath.row].name
        //listOfProductsByWeightViewController.weightOfWeightVC = _products[indexPath.row].weight
        UINavigationController.main.pushViewController(listOfProductsByWeightViewController, animated: true)
    }

}



