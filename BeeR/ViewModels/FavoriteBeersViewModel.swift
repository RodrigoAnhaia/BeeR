//
//  FavoriteBeersViewModel.swift
//  BeeR
//
//  Created by Rodrigo Sanseverino de Anhaia on 03/02/24.
//

import Foundation

class FavoriteBeersViewModel {
    
    //MARK: - Propreties
    
    let userDefaults = UserDefaults.standard
    public var favorites: [Int] = []
    
    init() {
        self.favorites = self.getFavorite()
    }
    
    //MARK: - Methods
    
    func addToFavorites(beersID: Int) {
        if !self.favorites.contains(beersID){
            self.favorites.append(beersID)
            self.userDefaults.set(self.favorites, forKey: "Favorites")
        } else {
            print("Could not save it, duplicate movie id \(beersID)")
        }
    }
    
    func getFavorite() -> [Int] {
        self.favorites = self.userDefaults.object(forKey: "Favorites") as? [Int] ?? []
        return self.favorites
        
    }
    
    func removeFromFavorites(beersID: Int) {
        if let index = self.favorites.firstIndex(of: beersID) {
            self.favorites.remove(at: index)
            self.userDefaults.set(self.favorites, forKey: "Favorites")
        }
        
    }
}
