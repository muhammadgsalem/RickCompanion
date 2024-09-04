//
//  DefaultDependencyContainer.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation
import APIGateProtocol
import DataRepositoryProtocol
import BusinessLayerProtocol

class DefaultDependencyContainer: DependencyContainerProtocol {
    public let networking: NetworkProtocol
    public let characterRepository: CharacterRepositoryProtocol
    public let fetchCharactersUseCase: FetchCharactersUseCaseProtocol

    public init(
            networking: NetworkProtocol = NetworkFactory.defaultNetworking(),
            characterRepository: CharacterRepositoryProtocol? = nil,
            fetchCharactersUseCase: FetchCharactersUseCaseProtocol? = nil
        ) {
            self.networking = networking
            self.characterRepository = characterRepository ?? CharacterRepositoryFactory.defaultRepository(networking: networking)
            self.fetchCharactersUseCase = fetchCharactersUseCase ?? FetchCharactersUseCaseFactory.defaultUseCase(characterRepository: self.characterRepository)
        }

    func makeCharactersViewModel() -> CharactersViewModelProtocol {
        return CharactersViewModel(fetchCharactersUseCase: fetchCharactersUseCase)
    }
    
    func makeCharactersViewController() -> CharactersViewController {
        let viewModel = makeCharactersViewModel()
        return CharactersViewController(viewModel: viewModel)
    }
    
    func makeCharacterDetailsViewController(character: Character, coordinator: CharactersCoordinator) -> CharacterDetailsViewController {
        let detailsViewController = CharacterDetailsViewController(character: character)
        detailsViewController.coordinator = coordinator
        return detailsViewController
    }
}
