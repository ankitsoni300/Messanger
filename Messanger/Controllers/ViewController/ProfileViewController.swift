//
//  ProfileViewController.swift
//  Messanger
//
//  Created by imart on 05/09/20.
//  Copyright © 2020 imart. All rights reserved.
//

import UIKit
import FirebaseAuth

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
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell else{
            return UITableViewCell()
        }
        
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.tableView.deselectRow(at: indexPath, animated: true)
            
            let actionSheetVC = UIAlertController(title: "Messanger", message: "Do you want to log out?", preferredStyle: .actionSheet)
            let actionLogout = UIAlertAction(title: "LogOut", style: .destructive) { [weak self] _ in
                do{
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
    
}


