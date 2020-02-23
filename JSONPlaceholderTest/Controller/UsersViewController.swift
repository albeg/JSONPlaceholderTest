//
//  UsersViewController.swift
//  JSONPlaceholderTest
//
//  Created by dragdimon on 21/02/2020.
//

import UIKit

class UsersViewController: UIViewController {

    //MARK: Properties
    private let networkClient = NetworkClient()
    private var users = [User]()
    private var photosForUser = [Int:[Photo]]()
    private var tableView = UITableView()
    
    //MARK: VC Lifecycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        self.title = "Users"
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch users and reload tableView
        networkClient.getUsers() { users, error in
            if let message = error?.localizedDescription {
                self.showError(message: message)
            } else {
                self.users = users
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: Utility methods
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UsersTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
}

    //MARK: TableView methods
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
        let cell = tableView.cellForRow(at: indexPath)
        let user = users[indexPath.row]
        let vc = PhotosViewController()
        vc.modalPresentationStyle = .fullScreen
        
        // Set photos that already exist
        if let photos = photosForUser[user.id] {
            vc.photos = photos
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            // Add acivityIndicator
            let indicator = UIActivityIndicatorView(style: .gray)
            cell?.accessoryView = indicator
            indicator.startAnimating()
            
            // Fetch albums for selected user
            networkClient.getAlbums(for: user.id) { (albums, error) in
                if let message = error?.localizedDescription {
                    self.showError(message: message)
                } else {
                    // Fetch photos for selected user
                    self.networkClient.getPhotos(for: albums) { (photos, error) in
                        if let message = error?.localizedDescription {
                            self.showError(message: message)
                        } else {
                            // Change activityIndicator to disclosureIndicator
                            cell?.accessoryView = nil
                            cell?.accessoryType = .disclosureIndicator
                            
                            // Add photos to dictionary and pass them to PhotosVC
                            self.photosForUser[user.id] = photos
                            vc.photos = photos
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


