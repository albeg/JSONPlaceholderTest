//
//  PhotoCell.swift
//  JSONPlaceholderTest
//
//  Created by dragdimon on 22/02/2020.
//

import UIKit

class PhotoCell: UITableViewCell {

    static var identifier: String = "PhotoCell"

    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.2
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.45
        
        return view
    }()
    
    let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .gray
        indicator.hidesWhenStopped = true
        indicator.isHidden = true
        
        return indicator
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setViews() {
        view.addSubview(photoImageView)
        view.addSubview(titleLabel)
        shadowView.addSubview(view)
        contentView.addSubview(shadowView)
        contentView.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            
            shadowView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            shadowView.widthAnchor.constraint(equalToConstant: 300),
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            view.widthAnchor.constraint(equalToConstant: 300),
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            photoImageView.topAnchor.constraint(equalTo: view.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 300),
            
            titleLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            indicator.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor)
        ])
    }
    
    
}
