//
//  ViewController.swift
//  BeeR
//
//  Created by Rodrigo Sanseverino de Anhaia on 30/01/24.
//

import UIKit

class BeerListViewController: UIViewController {
    private var localBeers: [Beers] = [Beers]()
    private var filteredBeer: [Beers]!
    
    private let beerTableView: UITableView = {
        let table = UITableView()
        table.register(BeerListViewCell.self, forCellReuseIdentifier: BeerListViewCell.identifier)
        table.separatorColor = .clear
        return table
    }()
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.tintColor = .black
        search.searchTextField.backgroundColor = .white
        search.sizeToFit()
        search.placeholder = "Search Beer..."
        return search
    }()
    
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
    }
}

extension BeerListViewController {
    fileprivate func fetchData() {
        APICaller.getBeers { [weak self] result in
            switch result {
            case .success(let beers):
                DispatchQueue.main.async {
                    self?.localBeers = beers
                    self?.filteredBeer = self?.localBeers
                    self?.beerTableView.reloadData()
                }
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    fileprivate func setupLayout() {
        self.view.addSubview(self.beerTableView)
        
    }
    
    fileprivate func configNavigationBar() {
        self.title = "Beer List"
        self.showsSearchBarButton(isHidden: true)
        
    }
    
    @objc func handleShowSearchBar() {
        self.showsSearch(isHidden: true)
        self.searchBar.becomeFirstResponder()
        self.navigationItem.titleView?.tintColor = .white
        
    }
    
    fileprivate func showsSearchBarButton(isHidden: Bool) {
        if isHidden {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .search,
                target: self,
                action: #selector(handleShowSearchBar))
            
        } else {
            self.navigationItem.rightBarButtonItem?.isHidden = true
            
        }
    }
    
    fileprivate func showsSearch(isHidden: Bool) {
        self.showsSearchBarButton(isHidden: !isHidden)
        self.navigationItem.titleView = isHidden ? self.searchBar : nil
        self.searchBar.showsCancelButton = isHidden
    }
}

extension BeerListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.showsSearch(isHidden: false)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            self.filteredBeer = self.localBeers
            self.beerTableView.reloadData()
            return
            
        }
        DispatchQueue.main.async {
            
            self.filteredBeer = self.localBeers.filter({ beer -> Bool in
                beer.name?.lowercased().contains(searchText.lowercased() ) ?? false })
            self.beerTableView.reloadData()
            //                for beer in self.localBeers {
            //                    if ((beer.name?.lowercased().contains(searchText.lowercased())) != nil) {
            //
            //                    }
            //                }
        }
    }
}

extension BeerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredBeer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BeerListViewCell.identifier, for: indexPath) as? BeerListViewCell else {
            return UITableViewCell()
        }
        
        let beer = self.filteredBeer[indexPath.row]
        
        cell.configure(with: BeerListViewModel(beerName: beer.name ?? "", tagline: beer.tagline ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let beer = self.localBeers[indexPath.row]
        
        DispatchQueue.main.async {
            let vc = BeerDetailsViewController()
            vc.title = "Beer Details"
            guard let name = beer.name,
                  let tagline = beer.tagline,
                  let description = beer.description else { return }
            
            
            vc.configure(with: BeerDetailsViewModel(beerName: name, tagline: tagline, description: description))
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
