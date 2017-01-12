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
import SwiftyVK

class ContainerViewController: BaseViewController {
    
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
    
    func addController(_ controller: UIViewController) {
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
        VK.logOut()
        User.deleteUser()
        let signInViewController = Storyboard.Login.instantiate()
        UINavigationController.main.pushViewController(signInViewController, animated: false)
    }
    
    func presetingSettingsViewController(_ viewcontroller: BaseViewController) {
        UINavigationController.main.present(viewcontroller, animated: true, completion: completion)
    }
    
    func getAllCategory () {
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
        UserRequest.getAllCategories(param as [String : AnyObject], completion: {[weak self] json in
            let category = Category(id: "", icon: "HeartCleanBillWhite", name: "Главная", created_at: "", units: "", category_id: "")
            var container = [Category]()
            container.append(category)
            json.forEach { _, json in
                print (">>self - \(json["name"])<<")
                let id = json["id"].string ?? ""
                let created_at = json["created_at"].string ?? ""
                let icon = json["icon"].string ?? ""
                let name = json["name"].string ?? ""
                let units = json["units"].string ?? ""
                let category_id = json["category_id"].string ?? ""
                
                let category = Category(id: id, icon: icon, name: name, created_at: created_at, units: units, category_id: category_id)
                container.append(category)
            }
            self?.categoryContainer = container
            self?.tableView?.reloadData()
        })
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
        
        let productDetails = categoryContainer[indexPath.row]
        Dispatch.mainQueue.async { _ in
            if indexPath.row == 0 {
                cell.thubnailImageView?.image = UIImage(named: productDetails.icon)
                cell.nameLabel?.text = productDetails.name
            } else {
                guard productDetails.icon.isEmpty == false, let imageData: Data = try? Data(contentsOf: URL(string: productDetails.icon)!) else { return }
                cell.thubnailImageView?.image = UIImage(data: imageData)
                cell.nameLabel?.text = productDetails.name
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 else { return }
        let categoryViewController = Storyboard.Category.instantiate()
        categoryViewController.categoryId = categoryContainer[indexPath.row].id
        categoryViewController.nameHeaderText = categoryContainer[indexPath.row].name
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
        containerViewController.addController(categoryViewController)
    }
}

