//
//  ProfileViewController.swift
//  Messanger
//
//  Created by imart on 05/09/20.
//  Copyright © 2020 imart. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = ["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func moveToLogin(){
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let logOutCell = self.tableView.dequeueReusableCell(withIdentifier: "logout", for: indexPath) as? ProfileTableViewCell else{
            return UITableViewCell()
        }
        
    
        logOutCell.textLabel?.text = data[indexPath.row]
        logOutCell.textLabel?.textAlignment = .center
        logOutCell.textLabel?.textColor = .red
        
        
        return logOutCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.tableView.deselectRow(at: indexPath, animated: true)
            
            let actionSheetVC = UIAlertController(title: "Messanger", message: "Do you want to log out?", preferredStyle: .actionSheet)
            let actionLogout = UIAlertAction(title: "LogOut", style: .destructive) { [weak self] _ in
                do{
                    GIDSignIn.sharedInstance()?.signOut()
                    let loginManager = LoginManager()
                    loginManager.logOut()
                    try Auth.auth().signOut()
                    self?.moveToLogin()
                }catch let error {
                    print(error.localizedDescription)
                }
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            actionSheetVC.addAction(actionLogout)
            actionSheetVC.addAction(actionCancel)
            
            self.present(actionSheetVC, animated: true, completion: nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let imageView = UIImageView(frame: CGRect(x: (self.tableView.width/2) - 52,
                                                  y: 11,
                                                  width: 105,
                                                  height: 105))
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        view.addSubview(imageView)
        view.backgroundColor = .link
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 127
    }
    
}


