//
//  BasketAfterPaymentViewController.swift
//  Mandarin
//
//  Created by Oleg on 1/10/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import Foundation

class BasketAfterPaymentViewController: BasketViewController {
    
    /* Here calls scene BasketAfterPayment without several elements */

   
    @IBAction func basketClickAndClearDatabase(_ sender: AnyObject) {
        
        ProductsForRealm.deleteAllProducts()
        updateProductInfo()
        
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
        containerViewController.addController(UIStoryboard.main["basket"]!)
    }

    @IBAction func searchClickAndClearDatabase(_ sender: AnyObject) {
        
        ProductsForRealm.deleteAllProducts()
        updateProductInfo()
        
        present(UIStoryboard.main["search"]!, animated: true, completion: nil)
        
    }
    
    @IBAction func menuClickAndClearDatabase(_ sender: AnyObject) {
        
        ProductsForRealm.deleteAllProducts()
        updateProductInfo()
        
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
        containerViewController.showMenu(!containerViewController.showingMenu, animated: true)
    }
}
