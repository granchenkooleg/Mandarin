//
//  MainViewController.swift
//  Mandarin
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentControlWrapper.segmentedCotrol.layer.cornerRadius = 5.0
        segmentControlWrapper.segmentedCotrol?.layer.borderColor = Color.mandarin.cgColor
        segmentControlWrapper.segmentedCotrol?.layer.borderWidth = 1.0
        segmentControlWrapper.segmentedCotrol?.layer.masksToBounds = true
        segmentControlWrapper.segmentedCotrol?.selectedSegment = 0
        
        segmentControlWrapper.setup([
            Storyboard.CategorySegment.instantiate(),
            Storyboard.FavoriteProducts.instantiate(),
            Storyboard.ListOfWeightProductsSegment.instantiate()],
                                     selectedControl: { [weak self] viewControllerr in
                                        self?.addController(viewControllerr)
        })
        selectTab(.category)
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


    
//    //MARK: Segue
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let categoryViewController = Storyboard.Category.instantiate()
//        categoryViewController.categoryId = _products[indexPath.row].id
//        categoryViewController.nameHeaderText = _products[indexPath.row].name
//        UINavigationController.main.pushViewController(categoryViewController, animated: true)
//    }
//    
//    override func searchTextChanged(sender: UITextField) {
//        super.searchTextChanged(sender: sender)
//        tableView.reloadData()
//    }
    
    
}
