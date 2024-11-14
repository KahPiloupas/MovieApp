//
//  NetworkHandler.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 12/11/24.
//

import Foundation

//Tratamento de erro genérico da pagina ao carregar ou quando nao existe filme na requisição
typealias NetworkResult<T: Decodable> = ((Result<T, NetworkError>) -> Void)

//Possíveis erros que pode apresentar na hora de fazer a requsição
struct NetworkRequest {
    var endpointURL: String
}

//Diferentes tipos de erros que podem apresentar
enum NetworkError: Error {
    case invalidURL(url: String)
    case networkError(error: Error)
    case invalidResponse
    case invalidStatusCode(statusCode: Int)
    case noData
    case decodeError(error: Error)
}

//Tipos de mensagens apresentadas
extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "URL inválida: \(url)"
        case .networkError(let error):
            return "Erro de rede: \(error.localizedDescription)"
        case .invalidResponse:
            return "Resposta inválida"
        case .invalidStatusCode(let statusCode):
            return "Status code inválido: \(statusCode)"
        case .noData:
            return "Dados não encontrados"
        case .decodeError(let error):
            return "Erro de decodificação: \(error.localizedDescription)"
        }
    }
}
