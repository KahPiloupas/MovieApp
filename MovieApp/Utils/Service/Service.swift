//
//  Service.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 12/11/24.
//

import Foundation

//Classe de requisição usando o URLSession pra buscar uma URL e o Decoder pra decodificar a resposta em uma resposta genérica e faz o tratamento dos erros de acordo com a response enviada na request

typealias NetworkResult = ((Result<Data, ApiError>) -> Void)

protocol ServiceProtocol {
    func performRequest(with url: URL) async throws -> Data
    func decodeJson(data: Data) async throws -> MovieResponse
}

class Service: ServiceProtocol {
    
    //Função performRequest transformada para assíncrona
    func performRequest(with url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        
        //Realizando a requisição usando URLSession com async/await
        let (data, response) = try await URLSession.shared.data(for: request)
        
        //Verificando o status de resposta HTTP
        if let response = response as? HTTPURLResponse, !(200...299 ~= response.statusCode) {
            throw ApiError.errorNetwork //Lança um erro se o código de status não for no range
        }
        
        return data //Retorna os dados
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
    case invalidURL
    case errorNetwork
    case noData
    case parseError
    case error(String)
}
