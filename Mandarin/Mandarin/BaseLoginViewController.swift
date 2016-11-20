//
//  BaseLoginViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/20/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CryptoSwift

class BaseLoginViewController: BaseViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet var helperButton: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButtonConfigure()
        configureFacebook()
    }
    
    func configureFacebook() {
        facebookLoginButton?.readPermissions = ["public_profile", "email", "user_friends"];
        facebookLoginButton?.loginBehavior = .systemAccount
        facebookLoginButton?.delegate = self
    }
    
    fileprivate func signInButtonConfigure() {
        let title = NSMutableAttributedString(string:helperButton.titleLabel?.text ?? "")
        let range = NSMakeRange(0, title.length)
        title.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
        title.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 15.0), range: range)
        title.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: range)
        helperButton.setAttributedTitle(title, for: UIControlState())
    }
    
    //MARK: Facebook handler
    
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, email, first_name, last_name, location"])
        let _  =  graphRequest?.start(completionHandler: { _, result, error in
            guard let result = result as? NSDictionary else { return }
            guard error == nil, let id = result["id"] else { return }
            let fbEntry = FBEntry(params: ["id": id as AnyObject])
            UserRequest.createUser(fbEntry, completion: {[weak self] in
                self?.chooseNextContoller()
                })
        })
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        UserRequest.logoutUser()
    }
    
    fileprivate func chooseNextContoller() {
        var appropriateVC: UIViewController = UIViewController()
        if User.isAuthorized() == true {
            appropriateVC = Storyboard.Container.instantiate()
        } else {
            appropriateVC = Storyboard.OnBoard.instantiate()
        }
        
        UINavigationController.main.pushViewController(appropriateVC, animated: false)
    }
}

class SignInViewController: BaseLoginViewController {
    
    @IBAction func helperButtonClick(_ sender: AnyObject) {
        
        navigationController?.pushViewController(Storyboard.Login.instantiate(), animated: true)
    }
    
    @IBAction func createAccount(_ sender: AnyObject) {
        //        navigationController?.pushViewController(Storyboard.CreateAccount.instantiate(), animated: true)
        present(Storyboard.RemoteCreate.instantiate(), animated: true, completion: nil)
    }
}

class LoginViewController: BaseLoginViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag + 1 {
        case passwordTextField.tag:
            passwordTextField.becomeFirstResponder()
        default: break
        }
        
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func helperButtonClick(_ sender: AnyObject) {
        navigationController?.pushViewController(Storyboard.CreateAccount.instantiate(), animated: true)
    }
    
    @IBAction func login(_ sender: Button) {
        sender.loading = true
        //        guard let email = emailTextField.text, let password = passwordTextField.text,
        //             email.isValidEmail == true && password.isEmpty == false else {
        //            UIAlertController.alert("Input data isn't valid.".ls).show()
        //            sender.loading = false
        //            return
        //        }
        
        //        let login = LoginEntry(params: ["email": "KyraSany@web.de", "password": "W87Sandra"])
        let login = LoginEntry(params: ["email": "ProftitTest@Proftit.com" as AnyObject, "password": "123456" as AnyObject])
        UserRequest.performAuthorization(login, completion: { success in
            if success == true {
                UINavigationController.main.pushViewController(Storyboard.OnBoard.instantiate(), animated: false)
            }
            
            sender.loading = false
        })
    }
    
    override func keyboardAdjustmentConstant(_ adjustment: KeyboardAdjustment, keyboard: Keyboard) -> CGFloat {
        return adjustment.defaultConstant + 60.0
    }
}

class CreateAccountViewController: BaseLoginViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: TextField!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var phoneTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag + 1 {
        case emailTextField.tag:
            emailTextField.becomeFirstResponder()
        case phoneTextField.tag:
            phoneTextField.becomeFirstResponder()
        case passwordTextField.tag:
            passwordTextField.becomeFirstResponder()
        default: break
        }
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func helperButtonClick(_ sender: AnyObject) {
        navigationController?.pushViewController(Storyboard.SignIn.instantiate(), animated: true)
    }
    
    @IBAction func createAccount(_ sender: Button) {
        sender.loading = true
        guard let userName = userNameTextField.text, let password = passwordTextField.text ,
            userName.isEmpty == false && password.isEmpty == false else {
                UIAlertController.alert("Invalid data.".ls).show()
                sender.loading = false
                return
        }
        guard let email = emailTextField.text , email.isValidEmail == true  else {
            UIAlertController.alert("Email isn't valid.".ls).show()
            sender.loading = false
            return
        }
        let login = LoginEntry(params: ["username": userName as AnyObject, "password": password as AnyObject])
        UserRequest.createUser(login, completion: {
            sender.loading = false
            UINavigationController.main.pushViewController(Storyboard.Container.instantiate(), animated: false)
        })
    }
    
    override func keyboardAdjustmentConstant(_ adjustment: KeyboardAdjustment, keyboard: Keyboard) -> CGFloat {
        return adjustment.defaultConstant + 145.0
    }
    
}
