//
//  FetchCharactersUseCaseProtocol.swift
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
public protocol FetchCharactersUseCaseProtocol {
    /// Executes the use case to fetch characters.
    ///
    /// - Parameters:
    ///   - page: The page number to fetch.
    ///   - status: The status filter to apply (if any).
    /// - Returns: A `CharacterResponse` containing the fetched characters and pagination info.
    /// - Throws: A `BusinessError` if the fetch operation fails.
    func execute(page: Int, status: String) async throws -> CharacterResponse
}

