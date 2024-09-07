//
//  DefaultFetchCharactersUseCase.swift
//  BusinessLayer
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation
import DataRepository

/// A use case that fetches characters from the repository.
///
/// This use case is responsible for:
/// - Interacting with the `CharacterRepositoryProtocol` to fetch characters
/// - Handling any business logic related to character fetching
/// - Mapping repository errors to business errors
final class FetchCharactersUseCase: FetchCharactersUseCaseProtocol {
    private let characterRepository: CharacterRepositoryProtocol

    /// Initializes a new instance of `FetchCharactersUseCase`.
    ///
    /// - Parameter characterRepository: The repository responsible for fetching character data.
    init(characterRepository: CharacterRepositoryProtocol) {
        self.characterRepository = characterRepository
    }

    /// Executes the use case to fetch characters.
    ///
    /// - Parameters:
    ///   - page: The page number to fetch.
    ///   - status: The status filter to apply (if any).
    /// - Returns: A `CharacterResponse` containing the fetched characters and pagination info.
    /// - Throws: A `BusinessError` if the fetch operation fails.
    func execute(page: Int, status: String) async throws -> CharacterResponse {
        do {
            return try await characterRepository.fetchCharacters(page: page, status: status)
        } catch {
            throw self.mapError(error)
        }
    }
    
    /// Maps repository errors to business errors.
    ///
    /// - Parameter error: The error to map.
    /// - Returns: A `BusinessError` corresponding to the input error.
    private func mapError(_ error: Error) -> BusinessError {
        if let repositoryError = error as? RepositoryError {
            return .repositoryError(repositoryError)
        } else {
            return .unknown(error)
        }
    }
}
