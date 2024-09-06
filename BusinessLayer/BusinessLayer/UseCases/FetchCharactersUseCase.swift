//
//  DefaultFetchCharactersUseCase.swift
//  BusinessLayer
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation
import DataRepository

final class FetchCharactersUseCase: FetchCharactersUseCaseProtocol {
    private let characterRepository: CharacterRepositoryProtocol

    init(characterRepository: CharacterRepositoryProtocol) {
        self.characterRepository = characterRepository
    }

    func execute(page: Int, status: String) async throws -> CharacterResponse {
        do {
            return try await characterRepository.fetchCharacters(page: page, status: status)
        } catch {
            throw self.mapError(error)
        }
    }
    
    private func mapError(_ error: Error) -> BusinessError {
        if let repositoryError = error as? RepositoryError {
            return .repositoryError(repositoryError)
        } else {
            return .unknown(error)
        }
    }
}
