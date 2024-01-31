//
//  ViewController.swift
//  BeeR
//
//  Created by Rodrigo Sanseverino de Anhaia on 30/01/24.
//

import UIKit

class BeerListViewController: UIViewController {
    private var localBeers: [Beers] = [Beers]()
    
    private let beerTableView: UITableView = {
        let table = UITableView()
        table.register(BeerListViewCell.self, forCellReuseIdentifier: BeerListViewCell.identifier)
        table.separatorColor = .clear
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavigationBar()
        self.setupLayout()
        
        self.beerTableView.dataSource = self
        self.beerTableView.delegate = self

        self.fetchData()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.beerTableView.frame = self.view.bounds
    }
   
    fileprivate func fetchData() {
        APICaller.getBeers { [weak self] result in
            switch result {
            case .success(let beers):
                DispatchQueue.main.async {
                    self?.localBeers = beers
                    self?.beerTableView.reloadData()
                }
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }

}

extension BeerListViewController {
    fileprivate func setupLayout() {
        self.view.addSubview(self.beerTableView)
    }
    
    fileprivate func configNavigationBar() {
        self.title = "Beer List"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearchBttn))
        
        
       
    }
    
    @objc func didTapSearchBttn() {
        let vc = BeerSearchViewController()
        vc.title = "Beer Search"
        vc.view.backgroundColor = .cyan
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BeerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.localBeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BeerListViewCell.identifier, for: indexPath) as? BeerListViewCell else {
            return UITableViewCell()
        }
        
        let beer = localBeers[indexPath.row]
        
        cell.configure(with: BeersViewModel(beerName: beer.name ?? "", tagline: beer.tagline ?? ""))
        
        return cell
    }
    
    
}
