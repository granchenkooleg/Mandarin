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
import FacebookCore
import FacebookLogin

class BaseLoginViewController: BaseViewController {
    
    fileprivate func chooseNextContoller() {
        var appropriateVC: UIViewController = UIViewController()
//        if User.isAuthorized() == true {
//            appropriateVC = Storyboard.Container.instantiate()
//        } else {
//            appropriateVC = Storyboard.OnBoard.instantiate()
//        }
        
        UINavigationController.main.pushViewController(appropriateVC, animated: false)
    }
}

class SignInViewController: BaseLoginViewController {
    
    @IBAction func helperButtonClick(_ sender: AnyObject) {
        
        navigationController?.pushViewController(Storyboard.Login.instantiate(), animated: true)
    }
    
    @IBAction func createAccount(_ sender: AnyObject) {
        //        navigationController?.pushViewController(Storyboard.CreateAccount.instantiate(), animated: true)
//        present(Storyboard.RemoteCreate.instantiate(), animated: true, completion: nil)
    }
}

class LoginViewController: BaseLoginViewController, UITextFieldDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    lazy var loginManager: LoginManager =  LoginManager()
    
    
    override func viewDidLoad() {
        GIDSignIn.sharedInstance().uiDelegate = self
        loginManager = LoginManager()
    }
    
    
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
    
    @IBAction func googleLogin(_ sender: Button) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func faceBookLogin(_ sender: Button) {
        sender.loading = true
        loginManager.logIn([ .publicProfile, .userFriends, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
            }
        }
    }
    
    override func keyboardAdjustmentConstant(_ adjustment: KeyboardAdjustment, keyboard: Keyboard) -> CGFloat {
        return adjustment.defaultConstant + 60.0
    }
    
    @IBAction func didTapGoogleSignOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    @IBAction func didTapFaceBookSignOut(sender: AnyObject) {
        loginManager.logOut()
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
//        let login = LoginEntry(params: ["username": userName as AnyObject, "password": password as AnyObject])
//        UserRequest.createUser(login, completion: {
//            sender.loading = false
//            UINavigationController.main.pushViewController(Storyboard.Container.instantiate(), animated: false)
//        })
    }
    
    override func keyboardAdjustmentConstant(_ adjustment: KeyboardAdjustment, keyboard: Keyboard) -> CGFloat {
        return adjustment.defaultConstant + 145.0
    }
    
}
