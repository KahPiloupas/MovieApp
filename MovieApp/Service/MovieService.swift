//
//  MovieService.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 10/11/24.
//

import Foundation

class MovieService {
    static let shared = MovieService()
    
    private init() {}
    
    func fetchPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=92e402ee413d95bf4784206801d2cb1e"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError()))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError()))
                return
            }
            print(String(data: data, encoding: .utf8))
            
            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(movieResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

