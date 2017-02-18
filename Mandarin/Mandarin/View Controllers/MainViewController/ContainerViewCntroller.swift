//
//  ContainerViewCntroller.swift
//  Mandarin
//
//  Created by Oleg on 11/20/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Foundation
import FacebookLogin
import FacebookCore

class ContainerViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var menuContainerView: Menu!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    var mainViewController: MainViewController? = nil
    var showingMenu = false
    
    //    func mainViewController () -> MainViewController? {
    //        guard let mainViewController = self.childViewControllers.first as? MainViewController else { return nil }
    //        return mainViewController
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuContainerView.completion = { [weak self] in
            self?.showMenu(false, animated: false)
        }
        guard let viewController = self.childViewControllers.first as? MainViewController? else { return }
        mainViewController = viewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showMenu(showingMenu, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if menuContainerView.is3DShowing {
            menuContainerView.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        }
    }
    
    func showMenu(_ show: Bool, animated: Bool) {
        let xOffset = menuContainerView.bounds.width
        scrollView.setContentOffset(show ? CGPoint.zero : CGPoint(x: xOffset, y: 0), animated: animated)
        showingMenu = show
        menuContainerView.setup()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let multiplier = 1.0 / menuContainerView.bounds.width
        let offset = scrollView.contentOffset.x * multiplier
        let fraction = 1.0 - offset
        menuContainerView.layer.transform = transformForFraction(fraction)
        
        
        scrollView.isPagingEnabled = scrollView.contentOffset.x < (scrollView.contentSize.width - scrollView.frame.width)
        
        let menuOffset = menuContainerView.bounds.width
        showingMenu = !CGPoint(x: menuOffset, y: 0).equalTo(scrollView.contentOffset)
    }
    
    func transformForFraction(_ fraction:CGFloat) -> CATransform3D {
        if menuContainerView.is3DShowing {
            var identity = CATransform3DIdentity
            identity.m34 = -1.0 / 1000.0;
            let angle = Double(1.0 - fraction) * -M_PI_2
            let xOffset = menuContainerView.bounds.width * 0.5
            let rotateTransform = CATransform3DRotate(identity, CGFloat(angle), 0.0, 1.0, 0.0)
            let translateTransform = CATransform3DMakeTranslation(xOffset, 0.0, 0.0)
            menuContainerView.alpha = fraction
            return CATransform3DConcat(rotateTransform, translateTransform)
        } else {
            return CATransform3DMakeTranslation(fraction, 0, 0)
        }
    }
    
    //    func addController(_ controller: UIViewController) {
    //        containerView.subviews.all({ $0.removeFromSuperview() })
    //        childViewControllers.all { $0.removeFromParentViewController() }
    //        addChildViewController(controller)
    //        containerView.addSubview(controller.view)
    //        containerView.add(controller.view) { $0.edges.equalTo(containerView) }
    //        controller.didMove(toParentViewController: self)
    //        view.layoutIfNeeded()
    //    }
    
    func addController(_ controller: UIViewController) {
        scrollView.isScrollEnabled = !(controller is BasketViewController)
        containerView.subviews.all({ $0.removeFromSuperview() })
        childViewControllers.all { $0.removeFromParentViewController() }
        addChildViewController(controller)
        containerView.addSubview(controller.view)
        containerView.add(controller.view) { $0.edges.equalTo(containerView) }
        controller.didMove(toParentViewController: self)
        view.layoutIfNeeded()
    }
    
}

class Menu: UIView, UITableViewDataSource, UITableViewDelegate {
    
    @IBInspectable var is3DShowing: Bool = false
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var loginButton: Button!
    var completion: Block? = nil
    var categoryContainer = [Category]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup()  {
        loginButton.setTitle(User.isAuthorized() ? "Выйти" : "Войти", for: .normal)
        getAllCategory()
    }
    
    @IBAction func logoutClick(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        LoginManager().logOut()
        VKSdk.forceLogout()
        User.deleteUser()
        let signInViewController = Storyboard.Login.instantiate()
        UINavigationController.main.dismiss(animated: true, completion: nil)
        UINavigationController.main.pushViewController(signInViewController, animated: false)
    }
    
    func presetingSettingsViewController(_ viewcontroller: BaseViewController) {
        UINavigationController.main.present(viewcontroller, animated: true, completion: completion)
    }
    
    func getAllCategory() {
        categoryContainer = Category().allCategories()
        categoryContainer.insert(Category(), at: 0)
        tableView?.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryContainer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CategoryTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CategoryTableViewCell
        
        let category = categoryContainer[indexPath.row]
        Dispatch.mainQueue.async { _ in
            if indexPath.row == 0 {
                cell.thubnailImageView?.image = UIImage(named: "ic_main")
                cell.nameLabel?.text = "Главная"
            } else {
                cell.thubnailImageView?.image = UIImage(data: category.image ?? Data())
                cell.nameLabel?.text = category.name
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 else {
            guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
            containerViewController.addController(containerViewController.mainViewController ?? UIViewController())
            containerViewController.showMenu(!containerViewController.showingMenu, animated: true)
            
            return
        }
        
        let categoryViewController = Storyboard.Category.instantiate()
        categoryViewController.categoryId = categoryContainer[indexPath.row].id
        categoryViewController.nameHeaderText = categoryContainer[indexPath.row].name
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
        containerViewController.addController(categoryViewController)
        containerViewController.showMenu(false, animated: true)
    }
}

