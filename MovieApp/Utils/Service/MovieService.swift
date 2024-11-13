//
//  MovieService.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 10/11/24.
//

import Foundation

//Service para fazer requisição de filmes populares
class MovieService {
    
    static let shared = MovieService()
    private let service = Service()
    private let baseURL = "https://api.themoviedb.org/3/movie/popular"
    private let apiKey = "92e402ee413d95bf4784206801d2cb1e"
    
    private init() {}
    
//Busca os filmes populares na requisição
    func fetchMovies(completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        
        let url = "\(baseURL)?api_key=\(apiKey)&page=1"
        //Aqui realizo a requisição
        service.request(url) { (result: Result<MovieResponse, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    completion(.success(success))
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }
        }
    }
    
//Busca por mais filmes pra preencher a collectionView conforme o numero de paginas da API
    func fetchMoreMovies(newPage: Int, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
       
        let url = "\(baseURL)?api_key=\(apiKey)&page=\(newPage)"
        service.request(url) { (result: Result<MovieResponse, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    completion(.success(success))
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }
        }
    }
}
