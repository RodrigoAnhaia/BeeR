//
//  BeerDetailsViewController.swift
//  BeeR
//
//  Created by Rodrigo Sanseverino de Anhaia on 31/01/24.
//

import UIKit

class BeerDetailsViewController: UIViewController {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let beerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let detailsLabel: UILabel = {
        let labelFrame = CGRect(x: 20, y: 20, width: 280, height: 150)
        let label = UILabel(frame: labelFrame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.minimumScaleFactor = 0.8
        label.sizeToFit()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.setupConstraint()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = .systemBackground
        
    }
}

extension BeerDetailsViewController {
    public func configure(with model: BeerDetailsViewModel) {
        self.nameLabel.text = model.beerName
        self.taglineLabel.text = model.tagline
        self.detailsLabel.text = model.description
        self.beerImageView.image = UIImage(named: "bottle")
    }
}

extension BeerDetailsViewController {
    fileprivate func setupLayout() {
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.taglineLabel)
        self.view.addSubview(self.beerImageView)
        self.view.addSubview(self.detailsLabel)
        
    }
    
    fileprivate func setupConstraint() {
        NSLayoutConstraint.activate([
            
            self.nameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            self.taglineLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 10),
            self.taglineLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            self.beerImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.beerImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.beerImageView.trailingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor, constant: -20),
            self.beerImageView.trailingAnchor.constraint(equalTo: self.taglineLabel.leadingAnchor, constant: -20),
            self.beerImageView.widthAnchor.constraint(equalToConstant: 80),

            self.detailsLabel.topAnchor.constraint(equalTo: self.beerImageView.bottomAnchor, constant: 40),
            self.detailsLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.detailsLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)

            ])
    }
}
