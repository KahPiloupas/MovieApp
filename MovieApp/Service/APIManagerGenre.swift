//
//  APIManagerGenre.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 10/11/24.
//

import Foundation

struct APIManagerGenre {
    static func fetchGenres(completion: @escaping ([Genre]) -> Void) {
        //URL para buscar os gêneros
        let urlString = "https://api.themoviedb.org/3/genre/movie/list?api_key=92e402ee413d95bf4784206801d2cb1e&language=en-US"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let genreResponse = try decoder.decode(GenreResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(genreResponse.genres)
                    }
                } catch {
                    print("Error decoding genres: \(error)")
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
