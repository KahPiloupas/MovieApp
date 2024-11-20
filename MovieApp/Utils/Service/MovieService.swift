//
//  MovieService.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 10/11/24.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchMovies(page: Int) async throws -> MovieResponse
}

//Service para fazer requisição de filmes populares
class MovieService: MovieServiceProtocol {
    
    let service = Service()
    
    private let baseURL = "https://api.themoviedb.org/3/movie/popular"
    private let apiKey = "92e402ee413d95bf4784206801d2cb1e"
    
    // Ajuste da função fetchMovies para ser assíncrona
    func fetchMovies(page: Int) async throws -> MovieResponse {
        //Criação da URL
        let url = URL(string: "\(baseURL)?api_key=\(apiKey)&page=\(page)")!
        
        //Usando performRequest de forma assíncrona
        let data = try await service.performRequest(with: url)  // Espera o resultado da requisição
        
        //Decodificando o JSON
        let responseObject = try await service.decodeJson(data: data)
        return responseObject //Retorna o objeto decodificado
    }
}

