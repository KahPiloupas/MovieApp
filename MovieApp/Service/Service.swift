//
//  Service.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 12/11/24.
//

import Foundation

//Classe de requisição usando o URLSession pra buscar uma URL e o Decoder pra decodificar a resposta em um objeto e faz o tratamento dos erros de acordo com a response recebida pela request

class Service {
    func performRequest(with url: URL) async throws -> Data {
        do {
            let request = URLRequest(url: url)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            //Verificando o status de resposta HTTP
            if let response = response as? HTTPURLResponse, !(200...299 ~= response.statusCode) {
                throw ApiError.errorNetwork //Lança um erro se o código de status não for no range de sucesso
            }
            
            return data //Retorna os dados
            
        } catch {
            throw ApiError.requestFailed //Lança erro caso a requisição falhe
        }
    }
    
    //Função decodeJson transformada para assíncrona (apesar de que a decodificação em si não precisa ser assíncrona)
    func decodeJson(data: Data) async throws -> MovieResponse {
        
        let decoder = JSONDecoder()
        
        do {
            //Decodificando o JSON de forma síncrona dentro de uma função assíncrona
            let decodeData = try decoder.decode(MovieResponse.self, from: data)
            return decodeData
            
        } catch {
            throw ApiError.parseError //Lança erro caso a decodificação falhe
        }
    }
}

public enum ApiError: Error {
    case requestFailed
    case errorNetwork
    case parseError
}
