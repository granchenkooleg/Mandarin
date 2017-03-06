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
//    var contentWeightProduct = Set<String>()
    var contentWeightProduct = [String]()
//    var contentWeightProductWithoutDuplicates = [String]()//Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if unitOfWeight == "kg" {
            unitOfWeight = "кг."
        }
        if unitOfWeight == "liter" {
            self.unitOfWeight = "л."
        }
        
        weightHeaderLabel.text = nameWeightHeaderText
       
        
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79", "category_id" : "\(podCategory_id)"]
        UserRequest.getWeightCategory(param as [String : AnyObject], completion: {[weak self] json in
            if  json[0].isEmpty {
                //It's null
                 let alertController = UIAlertController(title: "В этом разделе нет товара", message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
                    self?.backClick(nil)
                }
                self?.spiner.stopAnimating()
                alertController.addAction(OKAction)
                self?.present(alertController, animated: true)
                
                return
            }
            json.forEach { _, json in
                let weight = json["weight"].string ?? ""
                // Sort weight
//                self?.contentWeightProduct.insert(weight)
                self?.contentWeightProduct.append(weight)
                //self?.contentWeightProductWithoutDuplicates = (self?.contentWeightProduct.sorted {$0 < $1} ?? [])
            }
            self?.collectionView.reloadData()
            self?.spiner.stopAnimating()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return /*contentWeightProductWithoutDuplicates*/contentWeightProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weigthCell", for: indexPath)
            as? WeightCollectionViewCell else { return UICollectionViewCell() }
        cell.weightUnitsLabelOne.text = "\(/*contentWeightProductWithoutDuplicates*/contentWeightProduct[indexPath.row]) " + self.unitOfWeight
        
        //output icon: liter or kg
        if (self.unitOfWeight == "л.") {
            cell.iconWeightImageViev.image =  UIImage(named: "but")
        } else {
            cell.iconWeightImageViev.image =  UIImage(named: "weight")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width:  view.width/2 - 30, height: 71)
    }
    
    //MARK: Segue
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check Internet connection
        guard isNetworkReachable() == true  else {
            Dispatch.mainQueue.async {
                let alert = UIAlertController(title: "Нет Интернет Соединения", message: "Убедитесь, что Ваш девайс подключен к сети интернет", preferredStyle: .alert)
                let OkAction = UIAlertAction(title: "Ok", style: .default) {action in
                    
                }
                alert.addAction(OkAction)
                alert.show()
            }
            return
        }
        
        let listOfProductsByWeightViewController = Storyboard.ListOfWeightProducts.instantiate()
        listOfProductsByWeightViewController.nameListsOfProductsHeaderText = nameWeightHeaderText
        //for compare in ListsOfProductVC
        listOfProductsByWeightViewController.weightOfWeightVC = /*contentWeightProductWithoutDuplicates*/contentWeightProduct[indexPath.row]
        listOfProductsByWeightViewController.idPodcategory = podCategory_id
        listOfProductsByWeightViewController.unitOfWeightForListOfProductsByWeightVC = self.unitOfWeight
        
        listOfProductsByWeightViewController.addToContainer()
    }
    
}



