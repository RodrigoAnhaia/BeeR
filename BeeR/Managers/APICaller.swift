//
//  APICaller.swift
//  BeeR
//
//  Created by Rodrigo Sanseverino de Anhaia on 30/01/24.
//

import Foundation

struct Constant {
    static var baseURL = "https://api.punkapi.com/v2/beers?page="
}


class APICaller {
    private var page = 2
    private var moreBeers = [Beers]()
    public var isPaginating = false
    
    static let shared = APICaller()
    
    public static func getBeers(completion: @escaping (Result<[Beers], Error>)  -> Void) {
        guard let url = URL(string: "\(Constant.baseURL)1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode([Beers].self, from: data)
                completion(.success(results))
                
            } catch {
                completion(.failure(error))
                
            }
        }
        task.resume()
    }
    
    func fetchUrlLoadMore(paginating: Bool = false, completion: @escaping (Result<[Beers], Error>) -> Void) {
        guard let url = URL(string: "\(Constant.baseURL)\(page)") else { return }
        
        if paginating {
            self.isPaginating = true
            if self.page <= 12 {
                self.page += 1
            } else {
                print("end of api")
            }
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode([Beers].self, from: data)
                self.moreBeers.append(contentsOf: results)
                completion(.success(results))
                if paginating {
                    self.isPaginating = false 
                }
            
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
