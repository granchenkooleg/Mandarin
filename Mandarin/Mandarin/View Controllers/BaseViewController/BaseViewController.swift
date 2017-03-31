
//
//  BaseViewController.swift
//  Bezpaketov
//
//  Created by Oleg on 11/20/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import Alamofire

struct KeyboardAdjustment {
    let isBottom: Bool
    let defaultConstant: CGFloat
    let constraint: NSLayoutConstraint
    init(constraint: NSLayoutConstraint, isBottom: Bool = true) {
        self.isBottom = isBottom
        self.constraint = constraint
        self.defaultConstant = constraint.constant
    }
}

func performWhenLoaded<T: BaseViewController>(_ controller: T, block: @escaping (T) -> ()) {
    controller.whenLoaded { [weak controller] in
        if let controller = controller {
            block(controller)
        }
    }
}

class BaseViewController: UIViewController, KeyboardNotifying {
    
    // Realm data my table ProductsForRealm
    var productsInBasket: Results<ProductsForRealm>!
    
    var spiner = UIActivityIndicatorView()
    
    @IBInspectable var statusBarDefault = false
    
    @IBOutlet weak var navigationBar: UIView?
    
    var preferredViewFrame = UIWindow.mainWindow.bounds
    
    @IBOutlet lazy var keyboardAdjustmentLayoutViews: [UIView] = [self.view]
    
    var keyboardAdjustmentAnimated = true
    
    @IBOutlet weak var keyboardBottomGuideView: UIView?
    
    @IBOutlet weak var quantityCartLabel: UILabel?
    
    @IBOutlet weak var totalPriceLabel: UILabel?
    
    var viewAppeared = false
    
    fileprivate lazy var keyboardAdjustments: [KeyboardAdjustment] = []
    
    @IBOutlet var keyboardAdjustmentBottomConstraints: [NSLayoutConstraint] = []
    @IBOutlet var keyboardAdjustmentTopConstraints: [NSLayoutConstraint] = []
    
    deinit {
        Logger.debugLog("\(NSStringFromClass(type(of: self))) deinit", color: .Blue)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        super.loadView()
        
        if shouldUsePreferredViewFrame() {
            view.frame = preferredViewFrame
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if shouldUsePreferredViewFrame() {
            view.forceLayout()
        }
        var adjustments: [KeyboardAdjustment] = self.keyboardAdjustmentBottomConstraints.map({ KeyboardAdjustment(constraint: $0) })
        adjustments += self.keyboardAdjustmentTopConstraints.map({ KeyboardAdjustment(constraint: $0, isBottom: false) })
        keyboardAdjustments = adjustments
        if keyboardBottomGuideView != nil || !keyboardAdjustments.isEmpty {
            Keyboard.keyboard.addReceiver(self)
        }
        if !whenLoadedBlocks.isEmpty {
            whenLoadedBlocks.forEach({ $0() })
            whenLoadedBlocks.removeAll()
        }
    }
    
    fileprivate var whenLoadedBlocks = [Block]()
    
    func whenLoaded(_ block: @escaping Block) {
        if isViewLoaded {
            block()
        } else {
            whenLoadedBlocks.append(block)
        }
    }
    
    func shouldUsePreferredViewFrame() -> Bool {
        return true
    }
    
    static var lastAppearedScreenName: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateProductInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewAppeared = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewAppeared = false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    func keyboardAdjustmentConstant(_ adjustment: KeyboardAdjustment, keyboard: Keyboard) -> CGFloat {
        if adjustment.isBottom {
            return adjustment.defaultConstant + keyboard.height
        } else {
            return adjustment.defaultConstant - keyboard.height
        }
    }
    
    func keyboardBottomGuideViewAdjustment(_ keyboard: Keyboard) -> CGFloat {
        return keyboard.height
    }
    
    fileprivate func adjust(_ keyboard: Keyboard, willHide: Bool = false) {
        keyboardAdjustments.forEach({
            $0.constraint.constant = willHide ? $0.defaultConstant : keyboardAdjustmentConstant($0, keyboard:keyboard)
        })
        if keyboardAdjustmentAnimated && viewAppeared {
            keyboard.performAnimation({ keyboardAdjustmentLayoutViews.forEach ({ $0.layoutIfNeeded() }) })
        } else {
            keyboardAdjustmentLayoutViews.forEach({ $0.layoutIfNeeded() })
        }
    }
    
    func keyboardWillShow(_ keyboard: Keyboard) {
        if let keyboardBottomGuideView = keyboardBottomGuideView {
            keyboard.performAnimation({ () in
                keyboardBottomGuideView.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(view).inset(keyboardBottomGuideViewAdjustment(keyboard))
                })
                view.layoutIfNeeded()
            })
        } else {
            guard isViewLoaded && !keyboardAdjustments.isEmpty else { return }
            adjust(keyboard)
        }
    }
    
    func keyboardDidShow(_ keyboard: Keyboard) {}
    
    func keyboardWillHide(_ keyboard: Keyboard) {
        if let keyboardBottomGuideView = keyboardBottomGuideView {
            keyboard.performAnimation({ () in
                keyboardBottomGuideView.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(view)
                })
                view.layoutIfNeeded()
            })
        } else {
            guard isViewLoaded && !keyboardAdjustments.isEmpty else { return }
            adjust(keyboard, willHide: true)
        }
    }
    
    func keyboardDidHide(_ keyboard: Keyboard) {}
    
    //MARK: Back Button in headerq
    @IBAction func backClick(_ sender: AnyObject?) {
        if let containerVC = UINavigationController.main.topViewController as? ContainerViewController {
            if containerVC.presentedViewController != nil {
                self.dismiss(animated: true, completion: nil)
            } else if containerVC.navigation.viewControllers.count != 0 {
                
                containerVC.navigation.popViewController(animated: true)
            }
        }
        
        UINavigationController.main.popViewController(animated: true)
        
    }
    
    //MARK: Search
    @IBAction func searchClick(_ sender: Any) {
        let searchVC = UIStoryboard.main["search"] as? SearchViewController
        searchVC?.addToContainer()
    }
    
    //MARK: MenuClick
    @IBAction func menuClick(_ sender: AnyObject) {
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
        containerViewController.showMenu(!containerViewController.showingMenu, animated: true)
    }
    
    //MARK: Basket
    @IBAction func basketClick(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
        //        present(!, animated: true, completion: nil)
        let basketVC = UIStoryboard.main["basket"] as? BasketViewController
        basketVC?.addToContainer()
        
    }
    
    // MARK: Basket Update and totalPrice in header
    func updateProductInfo() {
        let realm = try! Realm()
        productsInBasket = realm.objects(ProductsForRealm.self)
        // We do check to display the data in the header
        let x = productsInBasket.map { Int($0.quantity) ?? 0 }.reduce(0, { $0 + $1 })
        if x > 0 {
            self.quantityCartLabel?.text = "\(productsInBasket.map { Int($0.quantity) ?? 0 }.reduce(0, { $0 + $1 }))"
            totalPriceLabel?.text = (totalPriceInCart() + " грн.")
        } else {
            self.quantityCartLabel?.text = ""
            totalPriceLabel?.text = ""
        }
    }
    
    //  Total price
    func totalPriceInCart() -> String {
        var totalPrice: Float = 0
        for product in  productsInBasket {
            // Make a choice prices for to display prices
            if Double(product.price_sale ?? "") ?? 0 > Double(0.00) {
                totalPrice += (Float(product.price_sale ?? "") ?? 0.0) * (Float(product.quantity) ?? 0.0)
            } else {
                totalPrice += (Float(product.price ?? "") ?? 0.0) * (Float(product.quantity) ?? 0.0)
            }
        }
        
        return String(totalPrice)
    }
    
    
    func addToContainer() {
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else {
            #if debug
                UIAlertController(title: "Warrning!", message: "controller didn't add to container - \(viewController)", preferredStyle: .alert).show()
            #endif
            return }
        
        containerViewController.pushViewController(self, animated: true)
    }
    
}
