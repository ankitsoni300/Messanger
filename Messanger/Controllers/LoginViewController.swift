//
//  LoginViewController.swift
//  Messanger
//
//  Created by imart on 05/09/20.
//  Copyright © 2020 imart. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Log In"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        //Add View
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = self.view.bounds
        let size = self.scrollView.width / 3
        self.imageView.frame = CGRect(x: (self.scrollView.width - size) / 2,
                                      y: 20,
                                      width: size,
                                      height: size)
    }
    
    @objc private func didTapRegister(){
        let registerVC = RegisterViewController()
        registerVC.title = "Register"
        self.navigationController?.pushViewController(registerVC, animated: true)
    }

}
