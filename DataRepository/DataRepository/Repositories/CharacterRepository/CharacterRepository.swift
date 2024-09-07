//
//  CharacterRepository.swift
//  BusinessLayer
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation
import APIGate

/// A repository that manages character data fetching from the network.
///
/// This repository is responsible for:
/// - Interacting with the `NetworkProtocol` to fetch character data
/// - Mapping network errors to repository errors
/// - Providing a clean API for the business layer to fetch characters
final class CharacterRepository: CharacterRepositoryProtocol {
    private let networking: NetworkProtocol

    /// Initializes a new instance of `CharacterRepository`.
    ///
    /// - Parameter networking: The networking service used to make API requests.
    init(networking: NetworkProtocol) {
        self.networking = networking
    }

    /// Fetches characters from the network.
    ///
    /// - Parameters:
    ///   - page: The page number to fetch.
    ///   - status: The status filter to apply (if any).
    /// - Returns: A `CharacterResponse` containing the fetched characters and pagination info.
    /// - Throws: A `RepositoryError` if the fetch operation fails.
    func fetchCharacters(page: Int, status: String) async throws -> CharacterResponse {
        let endpoint = CharactersEndpoint(page: page, status: status)
        do {
            return try await networking.request(endpoint)
        } catch {
            throw self.mapNetworkError(error)
        }
    }
    
    /// Maps network errors to repository errors.
    ///
    /// This method translates `NetworkError` instances into corresponding `RepositoryError` instances,
    /// providing a layer of abstraction between the networking and repository layers.
    ///
    /// - Parameter error: The network error to map.
    /// - Returns: A `RepositoryError` corresponding to the input error.
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
            return .invalidRequest
        }
    }
}
