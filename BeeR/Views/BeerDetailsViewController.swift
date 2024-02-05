//
//  BeerDetailsViewController.swift
//  BeeR
//
//  Created by Rodrigo Sanseverino de Anhaia on 31/01/24.
//

import UIKit

class BeerDetailsViewController: UIViewController {
    
    // MARK: - Propreties
    
    private var favoriteViewModel = FavoriteBeersViewModel()

    private var randomImage: [String] = ["1", "2", "3", "4", "5", "6", "7"]
    
    private var beersID: Int!
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.sizeToFit()
        return label
    }()
    
    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private let beerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
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
    
    private let favButton: UIButton = {
        let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .red
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.setupConstraint()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = .systemBackground
        self.favButton.addTarget(self, action: #selector(handleFavBttn), for: .touchUpInside)
        self.favButton.frame.size = CGSize(width: 40, height: 20)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.favoriteViewModel.favorites = self.favoriteViewModel.getFavorite()

    }
}

extension BeerDetailsViewController {
    
    //MARK: - Public Method
    
    public func configure(with model: BeerDetailsViewModel) {
        guard let url = URL(string: model.image_url) else { return }
        
        self.nameLabel.text = model.beerName
        self.taglineLabel.text = model.tagline
        self.detailsLabel.text = model.details
        self.beersID = model.id
        DispatchQueue.main.async {
            if model.image_url.contains("keg") {
                self.beerImageView.image = UIImage(named: self.randomImage.randomElement()!)
            } else {
                self.beerImageView.load(url: url)
                
            }
        }
        
        if self.favoriteViewModel.favorites.contains(where: { $0 == model.id }) {
            let image = UIImage(systemName: "heart.fill",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
            self.favButton.setImage(image, for: .normal)
            
        }
    }
    
    //MARK: - Actions
    
    @objc func handleFavBttn() {
        self.favoriteViewModel.addToFavorites(beersID: self.beersID)
        let image = UIImage(systemName: "heart.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        self.favButton.setImage(image, for: .normal)
        
    }
}

extension BeerDetailsViewController {
    // MARK: - Private Methods
    
    fileprivate func setupLayout() {
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.taglineLabel)
        self.view.addSubview(self.beerImageView)
        self.view.addSubview(self.detailsLabel)
        self.view.addSubview(self.favButton)
        
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
            self.beerImageView.heightAnchor.constraint(equalToConstant: 80),
            self.beerImageView.widthAnchor.constraint(equalToConstant: 40),
            
            self.detailsLabel.topAnchor.constraint(equalTo: self.beerImageView.bottomAnchor, constant: 40),
            self.detailsLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.detailsLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            self.favButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40),
            self.favButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.favButton.leadingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor, constant: -20),
            self.favButton.leadingAnchor.constraint(equalTo: self.taglineLabel.trailingAnchor, constant: -20),
            self.favButton.heightAnchor.constraint(equalToConstant: 20)
            
        ])
    }
}
