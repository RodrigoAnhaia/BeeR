//
//  ViewController.swift
//  BeeR
//
//  Created by Rodrigo Sanseverino de Anhaia on 30/01/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupHeaderView()
        self.view.backgroundColor = .blue
    }

    fileprivate func setupHeaderView() {
        APICaller.getBeers { [weak self] result in
            switch result {
            case .success(let beers):
                print(beers)
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }

}

