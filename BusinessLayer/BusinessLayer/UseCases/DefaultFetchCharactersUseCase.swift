//
//  DefaultFetchCharactersUseCase.swift
//  BusinessLayer
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation
import DataRepositoryProtocol

// Default implementation
public class DefaultFetchCharactersUseCase: FetchCharactersUseCaseProtocol {
    private let characterRepository: CharacterRepositoryProtocol

    public init(characterRepository: CharacterRepositoryProtocol) {
        self.characterRepository = characterRepository
    }

    public func execute(page: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
        characterRepository.fetchCharacters(page: page, completion: completion)
    }
}
