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
    func fetchMovies() async -> Result<MovieResponse,NetworkError> {
        
        let url = "\(baseURL)?api_key=\(apiKey)&page=1"
        
        do {
            let result: MovieResponse = try await
            service.request(url)
            return .success(result)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.networkError(error: error))
        }
    }
    
//Busca por mais filmes pra preencher a collectionView conforme o numero de paginas da API
    func fetchMoreMovies(page: Int) async -> Result<MovieResponse, NetworkError> {
        let url = "\(baseURL)?api_key=\(apiKey)&page=\(page)"
        
        do {
            let result: MovieResponse = try await service.request(url)
            return .success(result)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.networkError(error: error))
        }
    }
}
