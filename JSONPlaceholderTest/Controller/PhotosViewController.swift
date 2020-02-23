//
//  PhotosViewController.swift
//  JSONPlaceholderTest
//
//  Created by dragdimon on 21/02/2020.
//

import UIKit

class PhotosViewController: UIViewController {

    var photos = [Photo]()
    private let networkClient = NetworkClient()
    private let tableView = UITableView()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        self.title = "Photos"
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.identifier)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }

}

extension PhotosViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.identifier,
                                                 for: indexPath) as! PhotoCell
        let photo = photos[indexPath.row]
        
        cell.photoImageView.image = UIImage(named: "image")
        cell.titleLabel.text = photo.title
        
        cell.indicator.startAnimating()
        networkClient.downloadImage(path: photo.url) { (data, error) in
            guard let data = data else {
                return
            }
            cell.indicator.stopAnimating()
            cell.photoImageView.image = UIImage(data: data)
        }
        
        return cell
    }
    
}


