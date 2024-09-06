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

    func fetchCharacters(page: Int, status: String) async throws -> CharacterResponse {
        let endpoint = CharactersEndpoint(page: page, status: status)
        do {
            return try await networking.request(endpoint)
        } catch {
            throw self.mapNetworkError(error)
        }
    }
    
    private func mapNetworkError(_ error: Error) -> RepositoryError {
        guard let networkError = error as? NetworkError else {
            return .unknown(error)
        }
        
        switch networkError {
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
            return .unknown(networkError)
        }
    }
}
