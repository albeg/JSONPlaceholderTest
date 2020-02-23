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
    var photosForUser = [Int:[Photo]]()
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
        if users.count == 0 {
            self.tableView.setEmptyMessage("Users will be loaded soon!")
        } else {
            self.tableView.restore()
        }

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
        let vc = PhotosViewController()
        vc.modalPresentationStyle = .fullScreen
        
        if let photos = photosForUser[user.id] {
            vc.photos = photos
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let indicator = UIActivityIndicatorView(style: .gray)
            cell?.accessoryView = indicator
            indicator.startAnimating()
            
            networkClient.getAlbums(for: user.id) { (albums, error) in
                self.networkClient.getPhotos(for: albums) { (photos, error) in
                    cell?.accessoryView = nil
                    cell?.accessoryType = .disclosureIndicator
                    self.photosForUser[user.id] = photos
                    vc.photos = photos
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 25)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


