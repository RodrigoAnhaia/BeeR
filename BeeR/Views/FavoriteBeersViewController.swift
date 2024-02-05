//
//  FavoriteBeersViewController.swift
//  BeeR
//
//  Created by Rodrigo Sanseverino de Anhaia on 03/02/24.
//

import UIKit


class FavoriteBeersViewController: UIViewController {
    
    // MARK: - Propreties
    
    public var favoriteBeers = [Beers]()
    private var isFavoriteBeers = [Beers]()
    private var favoriteBeersViewModel = FavoriteBeersViewModel()
    
    private let favoriteBeersTableView: UITableView = {
        let table = UITableView()
        table.register(BeerListViewCell.self, forCellReuseIdentifier: BeerListViewCell.identifier)
        table.separatorColor = .clear
        return table
    }()
    
    private var config = UIContentUnavailableConfiguration.empty()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.favoriteBeersTableView.dataSource = self
        self.favoriteBeersTableView.delegate = self
        
        self.isFavoriteBeers = self.favoriteBeers.filter({
            self.favoriteBeersViewModel.getFavorite().contains($0.id) })
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.favoriteBeersTableView.frame = self.view.bounds
        
        
        self.config.image = UIImage(named: "placeholder")
        self.config.text = "No favorites were found"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            if !self.isFavoriteBeers.isEmpty {
                self.contentUnavailableConfiguration = nil
                
            } else {
                self.contentUnavailableConfiguration = self.config
                
            }
        }
    }
    
    // MARK: - Private Methods
    
    fileprivate func setupLayout() {
        self.view.addSubview(self.favoriteBeersTableView)
        
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource

extension FavoriteBeersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFavoriteBeers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            BeerListViewCell.identifier, for: indexPath) as? BeerListViewCell else {
            return UITableViewCell()
        }
        
        let beer = self.isFavoriteBeers[indexPath.row]
        
        cell.configure(with: BeerListViewModel(beerName: beer.name ?? "",
                                               tagline: beer.tagline ?? "",
                                               image_url: beer.image_url ?? ""))

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let beer = self.isFavoriteBeers[indexPath.row]
        
        DispatchQueue.main.async {
            let vc = BeerDetailsViewController()
            vc.title = "Beer Details"
            
            guard let name = beer.name,
                  let tagline = beer.tagline,
                  let description = beer.description,
                  let url = beer.image_url else { return }
            
            vc.configure(with: BeerDetailsViewModel(id: beer.id,
                                                    beerName: name,
                                                    tagline: tagline,
                                                    details: description,
                                                    image_url: url))
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:
                   UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let beer = self.isFavoriteBeers.remove(at: indexPath.row)
            self.favoriteBeersViewModel.removeFromFavorites(beersID: beer.id )
            self.favoriteBeersTableView.deleteRows(at: [indexPath], with: .automatic)
            DispatchQueue.main.async {
                self.favoriteBeersTableView.reloadData()
            }
        }
    }

}
