//
//  UsersViewController.swift
//  JSONPlaceholderTest
//
//  Created by dragdimon on 21/02/2020.
//

import UIKit

class UsersViewController: UIViewController {

    let networkClient = NetworkClient()
    var users = [User]()
    
    var tableView = UITableView()
    
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        setupTableView()
        self.title = "Users"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        networkClient.getUsers() { users, error in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UsersTableViewCell")
    }
    

}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell")!
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = "\(user.name)"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath)
        let indicator = UIActivityIndicatorView(style: .gray)
        cell?.accessoryView = indicator
        indicator.startAnimating()
        
        networkClient.getAlbums(for: user.id) { (albums, error) in
            self.networkClient.getPhotos(for: albums) { (photos, error) in
                
                cell?.accessoryView = nil
                cell?.accessoryType = .disclosureIndicator
                
                let vc = PhotosViewController()
                vc.photos = photos
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


