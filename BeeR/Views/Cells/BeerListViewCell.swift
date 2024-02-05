//
//  BeerListCell.swift
//  BeeR
//
//  Created by Rodrigo Sanseverino de Anhaia on 30/01/24.
//

import UIKit

class BeerListViewCell: UITableViewCell {
    
    // MARK: - Propreties
    
    static let identifier = "BeerListViewCell"
    private var randomImage: [String] = ["1", "2", "3", "4", "5", "6", "7"]
    
    private let grayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.9719485641, green: 0.9719484448, blue: 0.9719484448, alpha: 1)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
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
        imageView.sizeToFit()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let detailsButton: UIButton = {
        let image = UIImage(systemName: "chevron.forward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15))
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .gray
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Could not render \(BeerListViewCell.self)")
    }
    
    // MARK: - Public Methods
    
    public func configure(with model: BeerListViewModel) {
        guard let url = URL(string: model.image_url) else { return }
        
        self.nameLabel.text = model.beerName
        self.taglineLabel.text = model.tagline
        
        DispatchQueue.main.async {
            if model.image_url.contains("keg") {
                self.beerImageView.image = UIImage(named: self.randomImage.randomElement()!)
            } else {
                self.beerImageView.load(url: url)
                
            }
            
        }
    }
    
}

extension BeerListViewCell {
    
    // MARK: - Private Methods
    
    fileprivate func setupLayout() {
        self.contentView.addSubview(self.grayView)
        self.contentView.sendSubviewToBack(self.grayView)
        self.grayView.addSubview(self.nameLabel)
        self.grayView.addSubview(self.taglineLabel)
        self.grayView.addSubview(self.beerImageView)
        self.grayView.addSubview(self.detailsButton)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            self.grayView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.grayView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.grayView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.grayView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            
            self.nameLabel.topAnchor.constraint(equalTo: self.grayView.topAnchor, constant: 10),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.detailsButton.trailingAnchor, constant: -10),
            self.nameLabel.bottomAnchor.constraint(equalTo: self.taglineLabel.topAnchor, constant: 10),
            
            self.taglineLabel.trailingAnchor.constraint(equalTo: self.detailsButton.trailingAnchor, constant: -10),
            self.taglineLabel.bottomAnchor.constraint(equalTo: self.grayView.bottomAnchor, constant: -10),
            
            self.beerImageView.topAnchor.constraint(equalTo: self.grayView.topAnchor, constant: 10),
            self.beerImageView.leadingAnchor.constraint(equalTo: self.grayView.leadingAnchor, constant: 10),
            self.beerImageView.trailingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor, constant: -10),
            self.beerImageView.trailingAnchor.constraint(equalTo: self.taglineLabel.leadingAnchor, constant: -10),
            self.beerImageView.bottomAnchor.constraint(equalTo: self.grayView.bottomAnchor, constant: -10),
            self.beerImageView.heightAnchor.constraint(equalToConstant: 60),
            self.beerImageView.widthAnchor.constraint(equalToConstant: 40),

            
            self.detailsButton.topAnchor.constraint(equalTo: self.grayView.topAnchor, constant: 10),
            self.detailsButton.trailingAnchor.constraint(equalTo: self.grayView.trailingAnchor, constant: -20),
            self.detailsButton.bottomAnchor.constraint(equalTo: self.grayView.bottomAnchor, constant: -20)
        ])
    }
}
