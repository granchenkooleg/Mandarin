//
//  Storyboard+Ext.swift
//  BinarySwipe
//
//  Created by Macostik on 5/23/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import Foundation
import UIKit

func specify<T>(_ object: T, _ specify: (T) -> Void) -> T {
    specify(object)
    return object
}

struct StoryboardObject<T: UIViewController> {
    let identifier: String
    var storyboard: UIStoryboard
    init(_ identifier: String, _ storyboard: UIStoryboard = UIStoryboard.main) {
        self.identifier = identifier
        self.storyboard = storyboard
    }
    func instantiate() -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    func instantiate(_ block: (T) -> Void) -> T {
        let controller = instantiate()
        block(controller)
        return controller
    }
}

struct Storyboard {
    static let SignIn = StoryboardObject<SignInViewController>("signin", UIStoryboard.signUp)
    static let Login = StoryboardObject<LoginViewController>("login", UIStoryboard.signUp)
    static let CreateAccount = StoryboardObject<CreateAccountViewController>("createAccount", UIStoryboard.signUp)
    static let Container = StoryboardObject<ContainerViewController>("container")
    static let Main = StoryboardObject<MainViewController>("main")
    static let Category = StoryboardObject<CategoryViewController>("category")
    static let Weight = StoryboardObject<WeightViewController>("weight")
    static let ListOfWeightProducts = StoryboardObject<ListOfProductsByWeightViewController>("listOfWeightProducts")
    static let DetailsProduct = StoryboardObject<DetailsProductViewController>("detailsProduct")
    static let FavoriteProducts = StoryboardObject<FavoriteProductsViewController>("favorite")
    static let Search = StoryboardObject<SearchViewController>("search")
    static let ListOfWeightProductsSegment = StoryboardObject<ListOfProductsByWeightViewControllerSegment>("listOfWeightProductsSegment")
    static let CategorySegment = StoryboardObject<CategoryViewControllerSegment>("categorySegment")
    static let DrawingUpOrder = StoryboardObject<DrawingUpOfAnOrderViewController>("drawingUpOrder")
}

extension UIStoryboard {
    
    @nonobjc static let main = UIStoryboard(name: "Main", bundle: nil)
    @nonobjc static let signUp = UIStoryboard(name: "SignUp", bundle: nil)
    
    func present(_ animated: Bool) {
        UINavigationController.main.viewControllers = [instantiateInitialViewController()!]
    }
    
    subscript(key: String) -> UIViewController? {
        return instantiateViewController(withIdentifier: key)
    }
}

extension UIWindow {
    @nonobjc static let mainWindow = UIWindow(frame: UIScreen.main.bounds)
}

extension UINavigationController {
    
    @nonobjc static let main = specify(UINavigationController()) {
        UIWindow.mainWindow.rootViewController = $0
        UIWindow.mainWindow.makeKeyAndVisible()
        $0.isNavigationBarHidden = true
    }
    
    open override var shouldAutorotate : Bool {
        return topViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
    
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
}
