//
//  ConversationsViewController.swift
//  Messanger
//
//  Created by imart on 05/09/20.
//  Copyright © 2020 imart. All rights reserved.
//

import UIKit

class ConversationsViewController: UIViewController {

    //MARK:- ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let isLogin = UserDefaults.standard.bool(forKey: "isLogin")
        
        if !isLogin{
            //Open login page
            let loginVc = LoginViewController()
            let navigationVC = UINavigationController(rootViewController: loginVc)
            navigationVC.modalPresentationStyle = .fullScreen
            self.present(navigationVC, animated: false)
        }else{
            
        }
        
    }

}

