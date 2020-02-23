//
//  PhotosViewController.swift
//  JSONPlaceholderTest
//
//  Created by dragdimon on 21/02/2020.
//

import UIKit

class PhotosViewController: UIViewController {

    //MARK: Properties
    var photos = [Photo]()
    private let networkClient = NetworkClient()
    private let tableView = UITableView()
    private let imageCache = NSCache<NSString, UIImage>()
    
    //MARK: VC Lifecycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        self.title = "Photos"
        setupTableView()
    }
    
    //MARK: Utility methods
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.identifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
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

    //MARK: TableView methods
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
        
        // Get image from cache if it exists
        if let cachedImage = imageCache.object(forKey: photo.url as NSString) {
            cell.photoImageView.image = cachedImage
        } else {
            // DownloadImage for all user's albums
            cell.indicator.startAnimating()
            networkClient.downloadImage(path: photo.url) { (data, error) in
                guard let data = data else {
                    self.showError(message: error?.localizedDescription ?? "")
                    return
                }
                cell.indicator.stopAnimating()
                let image = UIImage(data: data)!
                self.imageCache.setObject(image, forKey: photo.url as NSString)
                cell.photoImageView.image = image
            }
        }
        return cell
    }
}


