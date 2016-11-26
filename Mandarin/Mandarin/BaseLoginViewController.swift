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
import SwiftyVK

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

class LoginViewController: BaseLoginViewController, UITextFieldDelegate, GIDSignInUIDelegate, VKDelegate {
    
    
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    lazy var loginManager: LoginManager =  LoginManager()
    
    
    override func viewDidLoad() {
        GIDSignIn.sharedInstance().uiDelegate = self
        loginManager = LoginManager()
        VK.configure(withAppId: "5748027", delegate: self)
    }
    
    
    
    
    //[special for VK]
    
    func vkWillAuthorize() -> Set<VK.Scope> {
        //Called when SwiftyVK need authorization permissions.
        return  [.offline]//an set of application permissions
    }
    
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        //Called when the user is log in.
        //Here you can start to send requests to the API.
        
//        let userId = parameters["user_id"]!
//        
//        var req = VK.API.Users.get([VK.Arg.userId: userId])
//        req.httpMethod = .GET
//        req.successBlock = { response in
//            let id = response.array![0]["id"].intValue
//            let firstName = response.array![0]["first_name"].stringValue
//            let lastName = response.array![0]["last_name"].stringValue
//            
//            print(id)
//            print(firstName)
//            print(lastName)
//    }
//        req.errorBlock = {
//            error in print(error)
//        }
//        req.send()
    }
    
    @IBAction func signInTouchUp(_ sender: AnyObject) {
        VK.logIn()
    }
    
    func vkAutorizationFailedWith(error: AuthError) {
        //Called when SwiftyVK could not authorize. To let the application know that something went wrong.
    }
    
    func vkDidUnauthorize() {
        //Called when user is log out.
    }
    
    func vkShouldUseTokenPath() -> String? {
        // ---DEPRECATED. TOKEN NOW STORED IN KEYCHAIN---
        //Called when SwiftyVK need know where a token is located.
        return nil//Path to save/read token or nil if should save token to UserDefaults
    }
    
    func vkWillPresentView() -> UIViewController {
        //Only for iOS!
        //Called when need to display a view from SwiftyVK.
        return self//UIViewController that should present authorization view controller
    }
    
    //func vkWillPresentView() -> NSWindow? {
       // //Only for OSX!
       // //Called when need to display a window from SwiftyVK.
        //return //Parent window for modal view or nil if view should present in separate window
    //}
    
    //[the end VK]
    
    
    
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
