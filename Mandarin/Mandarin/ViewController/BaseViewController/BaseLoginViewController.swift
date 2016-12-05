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
        guard User.isAuthorized() == true else { return }
        UINavigationController.main.pushViewController(Storyboard.Container.instantiate(), animated: false)
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

class LoginViewController: BaseLoginViewController, UITextFieldDelegate, GIDSignInUIDelegate, VKDelegate, GIDSignInDelegate {
    
    
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    @IBOutlet weak var vkButton: Button!
    @IBOutlet weak var facebookButton: Button!
    @IBOutlet weak var googleButton: Button!
    
    lazy var loginManager: LoginManager =  LoginManager()
    
    
    override func viewDidLoad() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        loginManager = LoginManager()
        VK.configure(withAppId: "5748027", delegate: self)
        
        setup()
    }
    
    func setup() {
        vkButton.circled = true
        facebookButton.circled = true
        googleButton.circled = true
    }
    
    func vkWillAuthorize() -> Set<VK.Scope> {
        return  [.offline]
    }
    
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        let userId = parameters["user_id"]!

        VK.API.Users.get([VK.Arg.userId: userId]).send(
            onSuccess: {[weak self] response in
                Dispatch.mainQueue.async({ _ in
                    User.setupUser(id: "\(response[0]["id"])", firstName: "\(response[0]["first_name"])", lastName: "\(response[0]["last_name"])")
                    self?.chooseNextContoller()
                })
        },
            onError: {error in print(error)}
        )
    }
    
    func vkAutorizationFailedWith(error: AuthError) {}
    
    func vkDidUnauthorize() {}
    
    func vkShouldUseTokenPath() -> String? {
        return nil
    }
    
    func vkWillPresentView() -> UIViewController {
        return self
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
    
    @IBAction func signInTouchUp(_ sender: AnyObject) {
        VK.logIn()
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
            case .success(_, _, _):
                print("Logged in!")
                let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, email, first_name, last_name, location"])
                let _  =  graphRequest?.start(completionHandler: {[weak self] _, result, error  in
                    guard let result = result as? NSDictionary else { return }
                    guard error == nil, let id = result["id"] else { return }
                    User.setupUser(id: "\(id)", firstName: "\(result["first_name"])", lastName: "\(result["last_name"])", email: "\(result["email"])")
                    self?.chooseNextContoller()
                })
            }
        }
    }
    
    override func keyboardAdjustmentConstant(_ adjustment: KeyboardAdjustment, keyboard: Keyboard) -> CGFloat {
        return adjustment.defaultConstant + 60.0
    }
    
    struct MyProfileRequest: GraphRequestProtocol {
        struct Response: GraphResponseProtocol {
            init(rawResponse: Any?) {
                // Decode JSON from rawResponse into other properties here.
            }
        }
        
        var graphPath = "/me"
        var parameters: [String : Any]? = ["fields": "id, name"]
        var accessToken = AccessToken.current
        var httpMethod: GraphRequestHTTPMethod = .GET
        var apiVersion: GraphAPIVersion = .defaultVersion
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            User.setupUser(id: user.userID, firstName: user.profile.givenName, lastName: user.profile.familyName, email: user.profile.email)
            chooseNextContoller()
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    private func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    @IBAction func loginClick(sender: Button) {
        sender.loading = true
        guard let email = emailTextField.text, let password = passwordTextField.text,
        email.isValidEmail == true && password.isEmpty == false else {
                UIAlertController.alert("Input data isn't valid.".ls).show()
                sender.loading = false
                return
        }
        let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79", "email" : /*"test1@mail.ru"*/ email, "password" : /*"123123"*/ password]
        UserRequest.makelogin(param as [String : AnyObject], completion: {[weak self] success in
            if success == true {
                self?.chooseNextContoller()
            }
            
            sender.loading = false
        })
    }
}

class CreateAccountViewController: BaseLoginViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    
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
    
//    @IBAction func helperButtonClick(_ sender: AnyObject) {
//        navigationController?.pushViewController(Storyboard.SignIn.instantiate(), animated: true)
//    }
    
    
    @IBAction func createAccount(_ sender: Button) {
        sender.loading = true
        guard let userName = userNameTextField.text, let password = passwordTextField.text ,
            userName.isEmpty == false && password.isEmpty == false else {
                UIAlertController.alert("Не введен пароль или ваше имя.".ls).show()
                sender.loading = false
                return
        }
        guard let email = emailTextField.text , email.isValidEmail == true  else {
            UIAlertController.alert("Неправильно введен адрес электронной почты.".ls).show()
            sender.loading = false
            return
        }
        
        let login = LoginEntry(params: ["username": userName as AnyObject, "password": password as AnyObject])
        UserRequest.createUser(login, completion: {
            sender.loading = false
            UINavigationController.main.pushViewController(Storyboard.Container.instantiate(), animated: false)
        })
        
        let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79", "email" : /*"test1@mail.ru"*/ email, "userName" : /*Oleg*/ userName , "password" : /*"123123"*/ password]
        UserRequest.createUser(param as [String : AnyObject], completion: {[weak self] success in
            if success == true {
                self?.chooseNextContoller()
            }
            
            sender.loading = false
            })
        
//        let login = LoginEntry(params: ["username": userName as AnyObject, "password": password as AnyObject])
//        UserRequest.createUser(login, completion: {
//            sender.loading = false
//           UINavigationController.main.pushViewController(Storyboard.Container.instantiate(), animated: false)
//        })
    }
    
    override func keyboardAdjustmentConstant(_ adjustment: KeyboardAdjustment, keyboard: Keyboard) -> CGFloat {
        return adjustment.defaultConstant + 145.0
    }
    
}
