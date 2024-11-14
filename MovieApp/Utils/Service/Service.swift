//
//  Service.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 12/11/24.
//

import Foundation

//Classe de requisição usando o URLSession pra buscar uma URL e o Decoder pra decodificar a resposta em uma resposta genérica e faz o tratamento dos erros de acordo com a response enviada na request
class Service {
    
    func request<T: Decodable>(_ request: String) async throws -> T {
        guard let url = URL(string: request) else {
            throw NetworkError.invalidURL(url: request)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidStatusCode(statusCode: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            throw NetworkError.decodeError(error: error)
        }
    }
    
}
