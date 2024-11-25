//
//  PersistenceManager.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 10/11/24.
//

import Foundation

class PersistenceManager {
    
    private static let favoritesKey = "favorites" //Chave pra armazenar os filmes favoritos
    
    //Carregar os filmes favoritos
    static func loadFavoriteMovies() -> [Movie] {
        //Existe dados armazenados para os favoritos?
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let movies = try? JSONDecoder().decode([Movie].self, from: data) else {
            return [] //Caso nao haja dados armazenados, retorna lista vazia
        }
        return movies
    }
    
    //Salvando os filmes favoritos
    static func saveFavoriteMovies(movies: [Movie]) {
        if let data = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
    
    //Verifica se um filme é favorito
    static func isFavorite(movie: Movie) -> Bool {
        let favorites = loadFavoriteMovies()
        return favorites.contains { $0.id == movie.id }
    }
    
    //Adiciona um filme aos favoritos
    static func addFavorite(movie: Movie) {
        var favorites = loadFavoriteMovies()
        if !favorites.contains(where: { $0.id == movie.id }) {
            favorites.append(movie)
            saveFavoriteMovies(movies: favorites)
        }
    }
    
    //Remove um filme dos favoritos
    static func removeFavorite(movie: Movie) {
        var favorites = loadFavoriteMovies()
        if let index = favorites.firstIndex(where: { $0.id == movie.id }) {
            favorites.remove(at: index)
            saveFavoriteMovies(movies: favorites)
        }
    }
    
    //Alternar o estado do filme favoritado
    static func toggleFavorite(movie: Movie) {
        if isFavorite(movie: movie) {
            removeFavorite(movie: movie)
        } else {
            addFavorite(movie: movie)
        }
    }
}
