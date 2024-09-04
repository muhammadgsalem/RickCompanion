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

    func execute(page: Int, completion: @escaping (Result<CharacterResponse, BusinessError>) -> Void) {
        characterRepository.fetchCharacters(page: page) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                let businessError = self.mapError(error)
                completion(.failure(businessError))
            }
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
