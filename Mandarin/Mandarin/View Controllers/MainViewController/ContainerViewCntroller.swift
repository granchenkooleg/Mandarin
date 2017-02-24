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
    var navigation = UINavigationController()
    
    // Create and add the view to the screen.
    let progressHUD = ProgressHUD(text: "Обновляем список товара...")
    
    var mainViewController: MainViewController = Storyboard.Main.instantiate()
    var showingMenu = false
    
    //    func mainViewController () -> MainViewController? {
    //        guard let mainViewController = self.childViewControllers.first as? MainViewController else { return nil }
    //        return mainViewController
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestForUpdateDB({})
        navigation.isNavigationBarHidden = true
        pushViewController(mainViewController, animated: false)
        menuContainerView.completion = { [weak self] in
            self?.showMenu(false, animated: false)
        }
        

         
       progressHUD.show()
        self.view.addSubview(progressHUD)
        

        self.view.backgroundColor = UIColor.black
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
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !self.childViewControllers.contains(navigation) {
            addController(navigation)
        }
        navigation.pushViewController(viewController, animated: animated)
    }
    
    // MARK: Request for update DB
    func requestForUpdateDB(_ completion: @escaping Block)  {
        
        DispatchQueue.global(qos: .userInteractive).async(execute: { [weak self] in
            let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
            UserRequest.listAllProducts(param as [String : AnyObject], completion: { [weak self] json in
                guard let weakSelf = self else {return}
                json.forEach { _, json in
                    print (">>self🔴 - \(json)<<")
                    let id = json["id"].string ?? ""
                    let created_at = json["created_at"].string ?? ""
                    let icon = json["icon"].string ?? ""
                    let name = json["name"].string ?? ""
                    let category_id = json["category_id"].string ?? ""
                    let weight = json["weight"].string ?? ""
                    let description = json["description"].string ?? ""
                    let brand = json["brand"].string ?? ""
                    let calories = json["calories"].string ?? ""
                    let proteins = json["proteins"].string ?? ""
                    let zhiry = json["zhiry"].string ?? ""
                    let uglevody = json["uglevody"].string ?? ""
                    let price = json["price"].string ?? ""
                    let favorite = json["favorite"].string ?? ""
                    let status = json["status"].string ?? ""
                    let expire_date = json["expire_date"].string ?? ""
                    var units = json["units"].string ?? ""
                    if units == "kg" {
                        units = "кг."
                    }
                    if units == "liter" {
                        units = "л."
                    }
                    let category_name = json["category_name"].string ?? ""
                    let price_sale = json["price_sale"].string ?? ""
                    var image: Data? = nil
                    if icon.isEmpty == false, let imageData = try? Data(contentsOf: URL(string: icon) ?? URL(fileURLWithPath: "")){
                        image = imageData
                    }
                    Product.setupProduct(id: id, description_: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody, units: units, image: image)
                }
                completion()
//                self?.spiner.stopAnimating()
            })
        })
        
        // Second request for update infoDB
        DispatchQueue.global(qos: .userInteractive).async(execute: { [weak self] in
            let param2: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
            UserRequest.getAllCategories(param2 as [String : AnyObject], completion: { json in
                json.forEach { _, json in
                    print (">>self🔵 - \(json)<<")

                    let id = json["id"].string ?? ""
                    let created_at = json["created_at"].string ?? ""
                    let icon = json["icon"].string ?? ""
                    let name = json["name"].string ?? ""
                    let units = json["units"].string ?? ""
                    //                /////////
                    //                let searchVC = qcg()
                    //                searchVC.unitOfWeightSearchVC = units
                    //                ////////
                    let category_id = json["category_id"].string ?? ""
                    var image: Data? = nil
                    if icon.isEmpty == false, let imageData = try? Data(contentsOf: URL(string: icon) ?? URL(fileURLWithPath: "")){
                        image = imageData
                        Category.setupCategory(id: id, icon: icon, name: name, created_at: created_at, units: units, category_id: category_id, image: image)
                    }
                }
                completion()
                self?.progressHUD.hide()
            })
        })
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
            //            containerViewController.pushViewController(containerViewController.mainViewController, animated: true)
            containerViewController.showMenu(!containerViewController.showingMenu, animated: false)
            
            return
        }
        
        let categoryViewController = Storyboard.Category.instantiate()
        categoryViewController.categoryId = categoryContainer[indexPath.row].id
        categoryViewController.nameHeaderText = categoryContainer[indexPath.row].name
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
        categoryViewController.addToContainer()
        containerViewController.showMenu(false, animated: true)
    }
    
}

