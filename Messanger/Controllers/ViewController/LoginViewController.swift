//
//  LoginViewController.swift
//  Messanger
//
//  Created by imart on 05/09/20.
//  Copyright © 2020 imart. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import JGProgressHUD

class LoginViewController: UIViewController {
    
    private var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private var emailField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email Address"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private var passwordField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        return field
    }()
    
    private var loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight : .bold)
        return button
    }()
    
    private let faceBookLoginButton : FBLoginButton = {
        let button = FBLoginButton()
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight : .bold)
        button.permissions = ["email","public_profile"]
        return button
    }()
    
    private let googleSignInButton : GIDSignInButton = {
        let button = GIDSignInButton()
        return button
    }()
    
    private var loginObserver : NSObjectProtocol?
    private let progressHud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLoginNotification, object: nil, queue: .main) { [weak self] _ in
            guard let strongSelf = self else{
                return
            }
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        self.view.backgroundColor = .white
        self.title = "Log In"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        self.loginButton.addTarget(self, action: #selector(btnLoginTapped), for: .touchUpInside)
        
        self.faceBookLoginButton.delegate = self
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
        //Add View
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imageView)
        self.scrollView.addSubview(self.emailField)
        self.scrollView.addSubview(self.passwordField)
        self.scrollView.addSubview(self.loginButton)
        self.scrollView.addSubview(self.faceBookLoginButton)
        self.scrollView.addSubview(self.googleSignInButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = self.view.bounds
        let size = self.scrollView.width / 3
        self.imageView.frame = CGRect(x: (self.scrollView.width - size) / 2,
                                      y: 20,
                                      width: size,
                                      height: size)
        
        self.emailField.frame = CGRect(x: 30,
                                       y: self.imageView.bottom + 10,
                                       width: self.scrollView.width - 60,
                                       height: 52)
        
        self.passwordField.frame = CGRect(x: 30,
                                          y: self.emailField.bottom + 10,
                                          width: self.scrollView.width - 60,
                                          height: 52)
        
        self.loginButton.frame = CGRect(x: 30,
                                        y: self.passwordField.bottom + 20,
                                        width: self.scrollView.width - 60,
                                        height: 52)
        
        self.faceBookLoginButton.frame = CGRect(x: 30, y: self.loginButton.bottom + 25, width: self.scrollView.width - 60, height: 52)
        
        self.googleSignInButton.frame = CGRect(x: 30, y: self.faceBookLoginButton.bottom + 25, width: self.scrollView.width - 60, height: 52)
        
    }
    
    deinit {
        if let loginObserver = loginObserver{
            NotificationCenter.default.removeObserver(loginObserver)
        }
    }
    
    @objc private func didTapRegister(){
        let registerVC = RegisterViewController()
        registerVC.title = "Register"
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc private func btnLoginTapped(){
        self.emailField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        self.progressHud.show(in: self.view)
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard let strongSelf = self else {return}
            DispatchQueue.main.async {
                strongSelf.progressHud.dismiss()
            }
            UserDefaults.standard.set(email, forKey: "email")
            guard error == nil else {return}
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops", message: "Please enter all information for login", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension LoginViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.emailField{
            self.passwordField.becomeFirstResponder()
        }else if textField == self.passwordField{
            self.passwordField.resignFirstResponder()
            self.btnLoginTapped()
        }
        
        return true
    }
    
}

extension LoginViewController : LoginButtonDelegate{
    
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print(loginButton)
    }
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("Failed to login in facebook")
            return
        }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: token)
        
        let fbRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields" : "email,first_name,last_name,picture.type(large)"], tokenString: token, version: nil, httpMethod: .get)
        
        fbRequest.start { (connection, result, error) in
            guard let result = result as? [String : Any], error == nil else {
                print("graph request failed")
                return
            }
            
            guard let firstName = result["first_name"] as? String, let lastName = result["last_name"] as? String, let userEmail = result["email"] as? String, let picture = result["picture"] as? [String:Any], let data = picture["data"] as? [String:Any], let urlString = data["url"] as? String else{
                return
            }
            
            UserDefaults.standard.set(userEmail, forKey: "email")
            
            DataBaseManager.shared.validateUser(with: userEmail) { (exists) -> (Void) in
                if !exists{
                    
                    let chatUser = UserData(userFirstName: firstName, userLastName: lastName, userEmail: userEmail)
                    
                    guard let fileName = chatUser.profilePicture else{
                        return
                    }
                    
                    DataBaseManager.shared.insertUser(model: chatUser, completion: { result in
                        if result{
                            
                            //Download data from fb image
                            
                            guard let url = URL(string: urlString) else {
                                return
                            }
                            
                            URLSession.shared.dataTask(with: url, completionHandler: { data, _,_ in
                                
                                guard let data = data else{
                                    return
                                }
                                //uploadImage
                                StorageManager.instance.uploadProfilePicToFirebase(data: data, fileName: fileName, completion: { result in
                                    
                                    switch result{
                                    case .success(let downloadUrl):
                                        
                                        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                        print("url")
                                        
                                    case .failure(let error):
                                        print("Storage maanger error: \(error)")
                                    }
                                    
                                })
                            }).resume()
                        }
                    })
                }
            }
            
            Auth.auth().signIn(with: credentials) { [weak self] (result, error) in
                guard let strongSelf = self else{
                    return
                }
                guard result != nil, error == nil else{
                    print("Facebook credentials fail")
                    return
                }
                
                print("Login Successfully")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
            
        }
        
    }
    
}
