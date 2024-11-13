//
//  Service.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 12/11/24.
//

import Foundation

//Classe de requisição usando o URLSession pra buscar uma URL e o Decoder pra decodificar a resposta em uma resposta genérica e faz o tratamento dos erros de acordo com a response enviada na request
class Service {
    
    func request<T: Decodable>(_ request: String, completion: @escaping NetworkResult<T>) {
        
        guard let url = URL(string: request) else {
            completion(.failure(NetworkError.invalidURL(url: request)))
            return
        }
        
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(NetworkError.networkError(error: error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard (200..<300).contains(response.statusCode) else {
                completion(.failure(NetworkError.invalidStatusCode(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(NetworkError.decodeError(error: error)))
            }

        }
        session.resume()
    }
}
