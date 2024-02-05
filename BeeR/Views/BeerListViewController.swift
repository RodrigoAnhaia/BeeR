//
//  ViewController.swift
//  BeeR
//
//  Created by Rodrigo Sanseverino de Anhaia on 30/01/24.
//

import UIKit

class BeerListViewController: UIViewController {
    
    // MARK: - Propreties
    
    private var localBeers: [Beers] = [Beers]()
    private var filteredBeer: [Beers]!
    
    private var config = UIContentUnavailableConfiguration.empty()
    
    private let beerTableView: UITableView = {
        let table = UITableView()
        table.register(BeerListViewCell.self, forCellReuseIdentifier: BeerListViewCell.identifier)
        table.separatorColor = .clear
        return table
    }()
    
    private var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.tintColor = .label
        return refresh
    }()
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.tintColor = .black
        search.searchTextField.backgroundColor = .white
        search.sizeToFit()
        search.placeholder = "Search Beer..."
        return search
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchData()
        
        self.configNavigationBar()
        self.setupLayout()
        
        self.beerTableView.dataSource = self
        self.beerTableView.delegate = self
        self.searchBar.delegate = self
        
        self.filteredBeer = self.localBeers
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.beerTableView.frame = self.view.bounds
        
        self.config.image = UIImage(named: "placeholder")
        self.config.text = "No results were found"
        
    }
}

extension BeerListViewController {
    
    // MARK: - Private Methods
    
    fileprivate func fetchData() {
        APICaller.getBeers { [weak self] result in
            switch result {
            case .success(let beers):
                self?.localBeers.append(contentsOf: beers)
                self?.filteredBeer = self?.localBeers
                DispatchQueue.main.async {
                    self?.beerTableView.reloadData()
                }
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    fileprivate func setupLayout() {
        self.view.addSubview(self.beerTableView)
        if #available(iOS 10.0, *) {
            self.beerTableView.refreshControl = self.refreshControl
            
        } else {
            self.beerTableView.addSubview(self.refreshControl)
            
        }
    }
    
    fileprivate func configNavigationBar() {
        self.title = "Beer List"
        self.showsSearchBarButton(isHidden: true)
        
    }
    
    fileprivate func showsSearchBarButton(isHidden: Bool) {
        if isHidden {
            let searchButton = UIBarButtonItem(
                barButtonSystemItem: .search,
                target: self,
                action: #selector(handleShowSearchBar))
            
            let favNaviButton = UIBarButtonItem(
                image: UIImage(systemName: "heart.fill"),
                style: .plain,
                target: self,
                action: #selector(handleFavoriteView))
            
            self.navigationItem.rightBarButtonItems = [searchButton, favNaviButton]
            
        } else {
            self.navigationItem.rightBarButtonItem?.isHidden = true
            
        }
    }
    
    fileprivate func showsSearch(isHidden: Bool) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            let cancelButton = UIBarButtonItem(
                barButtonSystemItem: .cancel,
                target: self,
                action: #selector(iPadHandleCancelButton))
            self.navigationItem.rightBarButtonItem = cancelButton
            
            
            self.showsSearchBarButton(isHidden: !isHidden)
            self.searchBar.showsCancelButton = isHidden
            self.navigationItem.titleView = isHidden ? self.searchBar : nil
            self.navigationItem.rightBarButtonItem?.isHidden = false
            
        } else {
            self.showsSearchBarButton(isHidden: !isHidden)
            self.searchBar.showsCancelButton = isHidden
            self.navigationItem.titleView = isHidden ? self.searchBar : nil
            
        }
    }
    
    // MARK: - Actions

    @objc func handleShowSearchBar() {
        self.showsSearch(isHidden: true)
        self.searchBar.becomeFirstResponder()
        self.navigationItem.titleView?.tintColor = .white
        
    }
    
    @objc func handleFavoriteView() {
        let vc = FavoriteBeersViewController()
        vc.title = "Favorites Beers"
        vc.favoriteBeers = self.filteredBeer
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func iPadHandleCancelButton(sender: AnyObject) {
        self.showsSearch(isHidden: false)
        
        searchBar.resignFirstResponder()
        
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem = nil
        
        self.showsSearchBarButton(isHidden: true)
        
    }
    
}

// MARK: - UISearchBarDelegate and UIScrollViewDelegate

extension BeerListViewController: UISearchBarDelegate, UIScrollViewDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.showsSearch(isHidden: false)
        self.contentUnavailableConfiguration = nil
        self.refreshControl.beginRefreshing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.refreshControl.endRefreshing()
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            self.filteredBeer = self.localBeers
            self.beerTableView.reloadData()
            self.contentUnavailableConfiguration = nil
            return
            
        }
        
        self.filteredBeer = self.localBeers.filter({ beer -> Bool in
            beer.name?.lowercased().contains(searchText.lowercased() ) ?? false
        })
        
        if !self.filteredBeer.isEmpty ||
            self.filteredBeer.contains(where: { $0.name?.lowercased() == searchText.lowercased() }) {
            self.contentUnavailableConfiguration = nil
            
        } else {
            self.contentUnavailableConfiguration = self.config
            
        }
        
        DispatchQueue.main.async {
            self.beerTableView.reloadData()
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = self.beerTableView.contentSize.height
        
        if (offsetY > contentHeight - 100 - scrollView.frame.height){
            
            guard !APICaller.shared.isPaginating else { return }
            
            APICaller.shared.fetchUrlLoadMore(paginating: true) { [weak self] result in
                switch result {
                case .success(let moreBeers):
                    self?.filteredBeer.append(contentsOf: moreBeers)
                    
                    DispatchQueue.main.async {
                        self?.beerTableView.reloadData()
                        
                    }
                case .failure(let error):
                    print(String(describing: error))
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource

extension BeerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredBeer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
                                                        BeerListViewCell.identifier, for: indexPath) as? BeerListViewCell else {
            return UITableViewCell()
        }
        
        let beer = self.filteredBeer[indexPath.row]
        
        cell.configure(with: BeerListViewModel(beerName: beer.name ?? "",
                                               tagline: beer.tagline ?? "",
                                               image_url: beer.image_url ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let beer = self.filteredBeer[indexPath.row]
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
