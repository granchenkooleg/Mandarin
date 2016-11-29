//
//  ContainerViewCntroller.swift
//  Mandarin
//
//  Created by Oleg on 11/20/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Foundation

class ContainerViewController: BaseViewController {
    
    @IBOutlet weak var menuContainerView: Menu!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var amountButton: UIButton!
    
    var showingMenu = false
    
//    func mainViewController () -> MainViewController? {
//        guard let mainViewController = self.childViewControllers.first as? MainViewController else { return nil }
//        return mainViewController
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        menuContainerView.completion = { [weak self] in
//            self?.showMenu(false, animated: false)
//        }
//        amountButton.setTitle(User.currentUser?.preferedAmountTrade , for: UIControlState())
//        User.notifier.subscribe(self, block: {[weak self] _, user in
//            Dispatch.mainQueue.async {
//                self?.amountButton.setTitle("\(user.preferedAmountTrade ?? "")" , for: UIControlState())
//            }
//            })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuContainerView.setup()
        showMenu(showingMenu, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuContainerView.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
    }
    
    func showMenu(_ show: Bool, animated: Bool) {
        let xOffset = menuContainerView.bounds.width
        scrollView.setContentOffset(show ? CGPoint.zero : CGPoint(x: xOffset, y: 0), animated: animated)
        showingMenu = show
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let multiplier = 1.0 / menuContainerView.bounds.width
        let offset = scrollView.contentOffset.x * multiplier
        let fraction = 1.0 - offset
        menuContainerView.layer.transform = transformForFraction(fraction)
        menuContainerView.alpha = fraction
        
        scrollView.isPagingEnabled = scrollView.contentOffset.x < (scrollView.contentSize.width - scrollView.frame.width)
        
        let menuOffset = menuContainerView.bounds.width
        showingMenu = !CGPoint(x: menuOffset, y: 0).equalTo(scrollView.contentOffset)
    }
    
    func transformForFraction(_ fraction:CGFloat) -> CATransform3D {
        var identity = CATransform3DIdentity
        identity.m34 = -1.0 / 1000.0;
        let angle = Double(1.0 - fraction) * -M_PI_2
        let xOffset = menuContainerView.bounds.width * 0.5
        let rotateTransform = CATransform3DRotate(identity, CGFloat(angle), 0.0, 1.0, 0.0)
        let translateTransform = CATransform3DMakeTranslation(xOffset, 0.0, 0.0)
        return CATransform3DConcat(rotateTransform, translateTransform)
    }
}

class Menu: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceButton: UIButton!
    var completion: Block? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup()  {
//        nameLabel.text = User.currentUser?.firstName
//        balanceButton.setTitle(User.currentUser?.statistic?.balance, for: UIControlState())
//        User.notifier.subscribe(self, block: {[weak self] in
//            self?.nameLabel.text = $1.firstName
//            self?.balanceButton.setTitle($1.statistic?.balance, for: UIControlState())
//            })
    }
    
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        sender.thumbTintColor = sender.isOn ? Color.green : UIColor(hex: 0x666d9f)
    }
    
    @IBAction func myAccountClick(_ sender: AnyObject) {
//        presetingSettingsViewController(Storyboard.Account.instantiate())
    }
    @IBAction func dashboardClick(_ sender: AnyObject) {
//        presetingSettingsViewController(Storyboard.DashBoard.instantiate())
    }
    @IBAction func withDrawClick(_ sender: AnyObject) {
//        presetingSettingsViewController(Storyboard.WithDrawProfits.instantiate())
    }
    @IBAction func recomenedBrokerClick(_ sender: AnyObject) {
    }
    @IBAction func tradesClick(_ sender: AnyObject) {
//        AmountTradeView.sharedView.show()
    }
    @IBAction func introductionClick(_ sender: AnyObject) {
//        let videoIntoductionVC = Storyboard.VideoIntoduction.instantiate()
//        performWhenLoaded(videoIntoductionVC, block: {
//            $0.showBackButton(true)
//        })
//        presetingSettingsViewController(videoIntoductionVC)
    }
    @IBAction func helpClick(_ sender: AnyObject) {
//        presetingSettingsViewController(Storyboard.Help.instantiate())
    }
    @IBAction func logoutClick(_ sender: AnyObject) {
        let signInViewController = Storyboard.SignIn.instantiate() as BaseLoginViewController
        UINavigationController.main.pushViewController(signInViewController, animated: false)
    }
    
    func presetingSettingsViewController(_ viewcontroller: BaseViewController) {
        UINavigationController.main.present(viewcontroller, animated: true, completion: completion)
        
    }
}
