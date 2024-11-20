//
//  APIManagerGenre.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 10/11/24.
//

import Foundation

struct APIManagerGenre {
    static func fetchGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        //URL para buscar os gêneros
        let urlString = "https://api.themoviedb.org/3/genre/movie/list?api_key=92e402ee413d95bf4784206801d2cb1e&language=en-US"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in //executa a task de requisiçao assincrona
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let genreResponse = try decoder.decode(GenreResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(genreResponse.genres))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

struct GenreResponse: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}
