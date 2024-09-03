//
//  CharactersViewModel.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation
import BusinessLayer

protocol CharactersViewModelProtocol {
    func loadCharacters(page: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void)
}

class CharactersViewModel: CharactersViewModelProtocol {
    private let fetchCharactersUseCase: FetchCharactersUseCase

    init(fetchCharactersUseCase: FetchCharactersUseCase) {
        self.fetchCharactersUseCase = fetchCharactersUseCase
    }

    func loadCharacters(page: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
        fetchCharactersUseCase.execute(page: page) { result in
            completion(result)
        }
    }
}
