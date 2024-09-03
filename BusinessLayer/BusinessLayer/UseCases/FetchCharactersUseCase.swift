//
//  FetchCharactersUseCase.swift
//  BusinessLayer
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation

public protocol FetchCharactersUseCaseProtocol {
    func execute(page: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void)
}

public class FetchCharactersUseCase: FetchCharactersUseCaseProtocol {
    private let characterRepository: CharacterRepositoryProtocol

    public init(characterRepository: CharacterRepositoryProtocol) {
        self.characterRepository = characterRepository
    }

    public func execute(page: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
        characterRepository.fetchCharacters(page: page, completion: completion)
    }
}
