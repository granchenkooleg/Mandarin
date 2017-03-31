//
//  MainViewController.swift
//  Bezpaketov
//
//  Created by Yuriy on 11/29/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import RealmSwift

enum SegmentTab: Int {
    
    case category, favorite, list
    
    func toString() -> String {
        switch self {
        case .category: return "category"
        case .favorite: return "favorite"
        case .list: return "list"
        }
    }
}

class SegmentControlWrapper: NSObject, SegmentedControlDelegate {
    
    @IBOutlet var segmentedCotrol: SegmentedControl!
    
    fileprivate var container = [String: UIViewController]()
    fileprivate var selectedControl: ((UIViewController) -> Void)?
    
    
    func setup(_ viewControllers: [UIViewController], selectedControl: @escaping ((UIViewController) -> Void)) {
        
        for (index, value) in viewControllers.enumerated() {
            self.container[SegmentTab(rawValue: index)?.toString() ?? ""] = value
        }
        
        segmentedCotrol?.delegate = self
        
        self.selectedControl = selectedControl
    }
    
    func viewController(_ segmentTab: SegmentTab) -> UIViewController? {
        switch segmentTab {
        case .category: return container[SegmentTab.category.toString()]
        case .favorite: return container[SegmentTab.favorite.toString()]
        case .list: return container[SegmentTab.list.toString()]
        }
    }
    
    //MARK: SegmentedControlDelegate
    
    func segmentedControl(_ control: SegmentedControl, didSelectSegment segment: Int) {
        guard let controller = viewController(SegmentTab(rawValue: segment)!) else { return }
        selectedControl?(controller)
    }
}


class MainViewController: BaseViewController {
    
    @IBOutlet var segmentControlWrapper: SegmentControlWrapper!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var bannerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // From ContainerVC if Internet connection
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.methodOfReceivedNotificationForMainVC(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        let category = Storyboard.CategorySegment.instantiate()
        let favorit = Storyboard.FavoriteProducts.instantiate()
        let list = Storyboard.ListOfWeightProductsSegment.instantiate()
        
        let basketHadler: Block = { [weak self] in
            self?.updateProductInfo()
        }
        
        list.basketHandler = basketHadler
        favorit.basketHandler = basketHadler
        // Configure Segmented Control
        segmentControlWrapper.segmentedCotrol.layer.cornerRadius = 5.0
        segmentControlWrapper.segmentedCotrol?.layer.borderColor = Color.Bezpaketov.cgColor
        segmentControlWrapper.segmentedCotrol?.layer.borderWidth = 1.0
        segmentControlWrapper.segmentedCotrol?.layer.masksToBounds = true
        //segmentControlWrapper.segmentedCotrol?.selectedSegment = 0
        
        segmentControlWrapper.setup([category, favorit, list],
                                    selectedControl: { [weak self] viewControllerr in
                                        self?.addController(viewControllerr)
        })
        
        // Check Internet connection
        guard isNetworkReachable() == true  else {
            
            return
        }
        
        // Call API method
        self.banner()
        if let queue = self.inactiveQueue {
            queue.activate()
        }
        
        // Toggle on CategoryVC
        selectTab(.category)
        
    }
    
    // NotificationCenter
    func methodOfReceivedNotificationForMainVC(notification: Notification){
        // Call API method
        self.banner()
        if let queue = self.inactiveQueue {
            queue.activate()
        }
        
        // Toggle on CategoryVC
        selectTab(.category)
    }
    
    var inactiveQueue: DispatchQueue!
    func banner()  {
        
        
        let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .userInitiated, attributes: [.concurrent, .initiallyInactive])
        inactiveQueue = anotherQueue
        
        anotherQueue.async(execute: { _ in
            //  Request for bannerImage
            let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79"]
            UserRequest.bannerImageforMainVC(param as [String : AnyObject], completion: {json in
                
                Dispatch.mainQueue.async {
                    let bannerImage = String(describing:json)
                    self.bannerImageView?.sd_setImage(with: URL(string: bannerImage))
                }
            })
        })
    }
    
    func selectTab(_ segmentTab: SegmentTab) {
        guard let controller = segmentControlWrapper.viewController(segmentTab) else { return }
        segmentControlWrapper.segmentedCotrol.selectedSegment = segmentTab.rawValue
        addController(controller)
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

