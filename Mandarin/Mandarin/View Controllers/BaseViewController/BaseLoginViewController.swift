//
//  BaseLoginViewController.swift
//  Bezpaketov
//
//  Created by Oleg on 11/20/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import FacebookCore
import FacebookLogin
import RealmSwift

class BaseLoginViewController: BaseViewController, UITextFieldDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate func chooseNextContoller() {
        guard User.isAuthorized() == true else { return }
        ProductsForRealm.deleteAllProducts()
        UINavigationController.main.viewControllers = [UIStoryboard.main["container"]!]
    }
    
    @IBAction func backToMain(sender: AnyObject) {
        ProductsForRealm.deleteAllProducts()
        dismiss(animated: true, completion: nil)
        //UINavigationController.main.popViewController(animated: false)
        UINavigationController.main.viewControllers = [UIStoryboard.main["container"]!]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return  textField.resignFirstResponder()
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

class TempVC: BaseLoginViewController {}

class LoginViewController: BaseLoginViewController, GIDSignInUIDelegate, GIDSignInDelegate, VKSdkDelegate, VKSdkUIDelegate {
    
    
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    @IBOutlet weak var vkButton: Button!
    @IBOutlet weak var facebookButton: Button!
    @IBOutlet weak var googleButton: Button!
    
    lazy var loginManager: LoginManager =  LoginManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        loginManager = LoginManager()
        VKSdk.instance().register(self)
        VKSdk.instance().uiDelegate = self
        
        setup()
    }
    
    func setup() {
        vkButton.circled = true
        facebookButton.circled = true
        googleButton.circled = true
    }
    
    //MARK: VKSdkDelegate
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        let scope = ["friends", "email"];
        VKSdk.wakeUpSession(scope, complete: { state, error in
            guard state == .authorized else { return }
            let request = VKApi.users().get()
            request?.execute(resultBlock: { [weak self] user in
                let userData = (user?.parsedModel as! VKUsersArray).firstObject()
                guard let id = userData?.id, let firstName = userData?.first_name, let lastName = userData?.last_name else { return }
                
                // For favorite products, because us need id [start
                let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                         "email" : "\(id)" + "@gmail.com",
                                         "username" : firstName,
                                         "password" : "\(id)"] as [String: Any]
                
                UserRequest.makeRegistration(param as [String : AnyObject], completion: {[weak self] success in
                    if success == true {
                        self?.chooseNextContoller()
                        
                    } else {
                        let param_2: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                                   "email" : "\(id)" + "@gmail.com",
                                                   "password" : "\(id)"] as [String: Any]
                        
                        UserRequest.makelogin(param_2 as [String : AnyObject], completion: {[weak self] success in
                            if success == true {
                                self?.chooseNextContoller()
                                
                            }
                        })
                    }
                })
                //end]
                
                self?.chooseNextContoller()
                }, errorBlock: { error in
            })
        })
    }
    
    public func vkSdkUserAuthorizationFailed() {  }
    
    @IBAction func signInTouchUp(_ sender: AnyObject) {
        let scope = ["friends", "email"];
        VKSdk.authorize(scope)
    }
    
    public func vkSdkShouldPresent(_ controller: UIViewController!) {
        if !VKSdk.vkAppMayExists() {
            present(controller, animated: true, completion: nil)
            
        }
    }
    public func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {}
    // the end VK
    
    @IBAction func googleLogin(_ sender: Button) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func faceBookLogin(_ sender: Button) {
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
                    
                    // For favorite products, because us need id [start
                    let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                             "email" : "\(id)" + "@gmail.com",
                                             "username" : "\(result["first_name"] ?? "")",
                        "password" : "\(id)"] as [String: Any]
                    
                    
                    UserRequest.makeRegistration(param as [String : AnyObject], completion: {[weak self] success in
                        if success == true {
                            self?.chooseNextContoller()
                            
                        } else {
                            let param_2: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                                       "email" : "\(id)" + "@gmail.com",
                                                       "password" : "\(id)"] as [String: Any]
                            
                            UserRequest.makelogin(param_2 as [String : AnyObject], completion: {[weak self] success in
                                if success == true {
                                    self?.chooseNextContoller()
                                    
                                }
                            })
                        }
                    })
                    //end]
                    
                    
                    self?.chooseNextContoller()
                })
            }
        }
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
            
            // For favorite products, because us need id [start
            let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                     "email" : user.userID + "@gmail.com",
                                     "username" : user.profile.givenName,
                                     "password" : user.userID] as [String: Any]
            
            
            UserRequest.makeRegistration(param as [String : AnyObject], completion: {[weak self] success in
                if success == true {
                    self?.chooseNextContoller()
                    
                } else {
                    let param_2: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                               "email" : user.userID + "@gmail.com",
                                               "password" : user.userID] as [String: Any]
                    
                    UserRequest.makelogin(param_2 as [String : AnyObject], completion: {[weak self] success in
                        if success == true {
                            self?.chooseNextContoller()
                            
                        }
                    })
                }
            })
            //end]
            
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
            email.isValidEmail == true || email.isEmpty == false && password.isEmpty == false else {
                UIAlertController.alert("Неверно введенный email или пароль".ls).show()
                sender.loading = false
                return
        }
        
        let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                 "email" : /*"test1@mail.ru"*/ email,
                                 "password" : /*"123123"*/ password]
        
        UserRequest.makelogin(param as [String : AnyObject], completion: {[weak self] success in
            if success == true {
                self?.chooseNextContoller()
            }
            
            sender.loading = false
        })
    }
}

class CreateAccountViewController: BaseLoginViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createAccount(_ sender: Button) {
        
        sender.loading = true
        
        guard let firstName = firstNameTextField.text, firstName.isEmpty == false else {
            UIAlertController.alert("Введите ваше имя".ls).show()
            self.firstNameTextField.text = ""
            sender.loading = false
            return
        }
        
        guard let phone = phoneTextField.text?.clearPhoneNumber(), phone.isEmpty == false else {
            UIAlertController.alert("Введите ваш номер телефона".ls).show()
            self.phoneTextField.text = ""
            sender.loading = false
            return
        }
        
        guard let email = emailTextField.text, email.isValidEmail == true  else {
            UIAlertController.alert("Неправильно введен адрес электронной почты".ls).show()
            self.emailTextField.text = ""
            sender.loading = false
            return
        }
        
        guard let password = passwordTextField.text,
            let repeatPassword = repeatPasswordTextField.text,
            password.isEmpty == false && repeatPassword.isEmpty == false && password == repeatPassword else {
                UIAlertController.alert("Пароли не совпадают".ls).show()
                self.passwordTextField.text = ""
                self.repeatPasswordTextField.text = ""
                sender.loading = false
                return
        }
        
        let birthday = birthdayTextField.text
        
        let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                 "email" : email,
                                 "username" : firstName,
                                 "password" : password,
                                 "phone" : phone,
                                 "birthday": birthday ?? ""] as [String: Any]
        
        UserRequest.makeRegistration(param as [String : AnyObject], completion: {[weak self] success in
            if success == true {
                self?.chooseNextContoller()
            } else {
                UIAlertController.alert("Такие данные уже используются".ls).show()
                self?.firstNameTextField.text = ""
                self?.phoneTextField.text = ""
                self?.emailTextField.text = ""
                self?.passwordTextField.text = ""
                self?.repeatPasswordTextField.text = ""
                self?.birthdayTextField.text = ""
            }
            
            InfoAboutUserForOrder.setupAllUserInfo(name: "\(firstName)", phone: "\(phone)", city: "Одесса")
            
            sender.loading = false
        })
        
    }
    
    override func keyboardAdjustmentConstant(_ adjustment: KeyboardAdjustment, keyboard: Keyboard) -> CGFloat {
        if (firstNameTextField.isFirstResponder) { return 0 }
        if (repeatPasswordTextField.isFirstResponder || birthdayTextField.isFirstResponder) {
            return adjustment.defaultConstant + 400
        }
        return adjustment.defaultConstant + 120
    }
}

class RecoveryPasswordViewController: BaseLoginViewController {
    
    
    @IBOutlet weak var emailOrPhoneTextField: UITextField!
    
    @IBAction func sendButton(sender: Button) {
        
        sender.loading = true
        guard let emailOrPhone = emailOrPhoneTextField.text, emailOrPhone.isEmpty == false else {
            UIAlertController.alert("Введите ваш email или номер телефона".ls).show()
            sender.loading = false
            return
        }
        
        let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                 "email" : /*"test1@mail.ru"*/ emailOrPhone,
                                 "password" : "111222" /*password*/]
        
        UserRequest.recoveryPassword(param as [String : AnyObject], completion: { success in
            if success == true {
                //self?.chooseNextContoller()
                UINavigationController.main.pushViewController(Storyboard.Login.instantiate(), animated: false)
                if let _ = Int(emailOrPhone)
                {
                    UIAlertController.alert("Новый пароль выслан на Ваш номер телефона".ls).show()
                    
                }
                else
                {
                    UIAlertController.alert("Новый пароль выслан на Ваш email".ls).show()
                    
                }
                
            }
            sender.loading = false
        })
        
    }
    
}

