//
//  NewConversationViewController.swift
//  Messanger
//
//  Created by imart on 05/09/20.
//  Copyright © 2020 imart. All rights reserved.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
    
    let progressHud = JGProgressHUD(style: .dark)
    
    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users.."
        return searchBar
    }()
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let noResultLabel : UILabel = {
        let noResultLabel = UILabel()
        noResultLabel.isHidden = true
        noResultLabel.text = "No result found"
        noResultLabel.textAlignment = .center
        noResultLabel.textColor = .gray
        noResultLabel.font = .systemFont(ofSize: 21, weight: .medium)
        return noResultLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(btnCancel))
        self.view.backgroundColor = .white
        self.searchBar.delegate = self
        self.searchBar.becomeFirstResponder()
    }
    
    @objc private func btnCancel(){
        self.dismiss(animated: true, completion: nil)
    }

}

extension NewConversationViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}
