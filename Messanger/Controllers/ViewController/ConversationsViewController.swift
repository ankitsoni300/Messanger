//
//  ConversationsViewController.swift
//  Messanger
//
//  Created by imart on 05/09/20.
//  Copyright © 2020 imart. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ConversationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let noConversationLabel : UILabel = {
        let label = UILabel()
        label.text = "No Conversation"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    private let progressHud = JGProgressHUD(style: .dark)
    
    //MARK:- ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isHidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        self.fetchConversations()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if (Auth.auth().currentUser == nil){
            //Open login page
            let loginVc = LoginViewController()
            let navigationVC = UINavigationController(rootViewController: loginVc)
            navigationVC.modalPresentationStyle = .fullScreen
            self.present(navigationVC, animated: false)
        }else{
            
        }
        
    }
    
    @objc private func didTapComposeButton(){
        let vc = NewConversationViewController()
        let navVc = UINavigationController(rootViewController: vc)
        self.present(navVc, animated: true)
    }
    
    private func fetchConversations(){
        self.tableView.isHidden = false
    }

}

extension ConversationsViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ConversationsTableViewCell", for: indexPath) as? ConversationsTableViewCell else{
            return UITableViewCell()
        }
        cell.textLabel?.text = "Hello World"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController()
        vc.title = "Ankit Soni"
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

