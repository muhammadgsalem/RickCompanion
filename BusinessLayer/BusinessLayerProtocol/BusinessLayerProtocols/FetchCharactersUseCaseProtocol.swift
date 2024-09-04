//
//  FetchCharactersUseCaseProtocol.swift
//  BusinessLayer
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation
import DataRepositoryProtocol

public protocol FetchCharactersUseCaseProtocol {
    func execute(page: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void)
}

public enum FetchCharactersUseCaseFactory {
    public static func defaultUseCase(characterRepository: CharacterRepositoryProtocol = CharacterRepositoryFactory.defaultRepository()) -> FetchCharactersUseCaseProtocol {
        return DefaultFetchCharactersUseCase(characterRepository: characterRepository)
    }
}
