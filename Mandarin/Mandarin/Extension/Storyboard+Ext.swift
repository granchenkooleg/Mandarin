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
//    static let RemoteCreate = StoryboardObject<RemoteCreateAccountViewController>("remote", UIStoryboard.signUp)
//    
//    static let OnBoard = StoryboardObject<OnBoardViewController>("introduction", UIStoryboard.introduction)
//    static let Introduction_Item = StoryboardObject<PageItem>("pageItem",  UIStoryboard.introduction)
//    static let VideoIntoduction = StoryboardObject<VideoIntroductionViewController>("videoIntroduction", UIStoryboard.introduction)
//    
//    static let Container = StoryboardObject<ContainerViewController>("container")
//    static let Main = StoryboardObject<MainViewController>("main")
//    static let SearchSignals = StoryboardObject<SearchSinalsViewController>("searchSignals")
//    static let LiveSignals = StoryboardObject<LiveSignalsViewController>("liveSignals")
//    static let AlertFunds = StoryboardObject<AlertFundsViewController>("alertFunds")
//    static let FundAccount = StoryboardObject<FundAccountViewController>("fundAccount")
//    static let SuccessFund = StoryboardObject<SuccessFundViewController>("successFund")
//    static let Trade = StoryboardObject<TradeViewController>("trade")
//    static let Deposit = StoryboardObject<DepositViewController>("deposit")
//    
//    static let Account = StoryboardObject<AccountViewController>("account")
//    static let DashBoard = StoryboardObject<DashboardViewController>("dashboard")
//    static let WithDrawProfits = StoryboardObject<WithDrawProfitsViewController>("withdraw_profits")
//    static let Settings = StoryboardObject<SettingsViewController>("settings")
//    static let Help = StoryboardObject<HelpViewController>("help")
}

extension UIStoryboard {
    
    @nonobjc static let main = UIStoryboard(name: "Main", bundle: nil)
    @nonobjc static let introduction = UIStoryboard(name: "Introduction", bundle: nil)
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
        $0.isNavigationBarHidden = true
    }
    
    open override var shouldAutorotate : Bool {
        return topViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
    
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
}
