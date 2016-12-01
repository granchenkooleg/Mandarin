//
//  BaseViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/20/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import UIKit
import Foundation

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
    
    @IBInspectable var statusBarDefault = false
    
    @IBOutlet weak var navigationBar: UIView?
    
    var preferredViewFrame = UIWindow.mainWindow.bounds
    
    @IBOutlet lazy var keyboardAdjustmentLayoutViews: [UIView] = [self.view]
    
    var keyboardAdjustmentAnimated = true
    
    @IBOutlet weak var keyboardBottomGuideView: UIView?
    
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
    
    //Back Button in header
    @IBAction func backClick(_ sender: AnyObject) {
        if ((self.presentedViewController) != nil) {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
//    @IBAction func back(_ sender: AnyObject) {
//        UINavigationController.main.dismiss(animated: true, completion: nil)
//    }
}
