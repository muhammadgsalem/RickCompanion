//
//  CharacterRepository.swift
//  BusinessLayer
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation
import APIGate

final class CharacterRepository: CharacterRepositoryProtocol {
    private let networking: NetworkProtocol

    init(networking: NetworkProtocol) {
        self.networking = networking
    }

    func fetchCharacters(page: Int, completion: @escaping (Result<CharacterResponse, RepositoryError>) -> Void) {
        let endpoint = CharactersEndpoint(page: page)
        networking.request(endpoint) { (result: Result<CharacterResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let networkError):
                let repositoryError = self.mapNetworkError(networkError)
                completion(.failure(repositoryError))
            }
        }
    }
    
    private func mapNetworkError(_ error: NetworkError) -> RepositoryError {
        switch error {
        case .invalidURL:
            return .invalidRequest
        case .invalidResponse, .decodingError:
            return .invalidResponse
        case .serverError(let statusCode):
            return .serverError(statusCode: statusCode)
        case .noData:
            return .noData
        case .unknownError(let underlyingError):
            return .unknown(underlyingError)
        @unknown default:
            return .noData
        }
    }
}
