//
//  APICaller.swift
//  BeeR
//
//  Created by Rodrigo Sanseverino de Anhaia on 30/01/24.
//

import Foundation

struct Constant {
    static var baseURL = "https://api.punkapi.com/v2/beers"
}


class APICaller {
    static let shared = APICaller()
    
    public static func getBeers(completion: @escaping (Result<[Beers], Error>)  -> Void) {
        guard let url = URL(string: "\(Constant.baseURL)") else { return }
        
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
}
