//
//  DefaultDependencyContainer.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import APIGate
import BusinessLayer
import DataRepository
import Foundation

final class DependencyContainer: DependencyContainerProtocol {
    
    static let shared = DependencyContainer()
    
    private let apiGateDIContainer: APIGateDIContainer
    private let dataRepositoryDIContainer: DataRepositoryDIContainer
    private let businessLayerDIContainer: BusinessLayerDIContainer
    
    private init(
        apiGateDIContainer: APIGateDIContainer = .shared,
        dataRepositoryDIContainer: DataRepositoryDIContainer = .shared,
        businessLayerDIContainer: BusinessLayerDIContainer = .shared
    ) {
        self.apiGateDIContainer = apiGateDIContainer
        self.dataRepositoryDIContainer = dataRepositoryDIContainer
        self.businessLayerDIContainer = businessLayerDIContainer
    }
    
    func makeCharactersViewModel() -> CharactersViewModelProtocol {
        CharactersViewModel(fetchCharactersUseCase: businessLayerDIContainer.makeFetchCharactersUseCase())
    }
    
    func makeCharactersViewController(coordinator: CharactersCoordinator) -> CharactersViewController {
        let viewModel = makeCharactersViewModel()
        let viewController = CharactersViewController(viewModel: viewModel)
        viewController.coordinator = coordinator
        return viewController
    }
    
    func makeCharacterDetailsViewController(character: Character, coordinator: CharacterDetailCoordinator) -> CharacterDetailsViewController {
        CharacterDetailsViewController(character: character, coordinator: coordinator)
    }
}
