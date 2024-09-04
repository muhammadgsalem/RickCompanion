//
//  DependencyContainerProtocol.swift
//  RickCompanion
//
//  Created by Jimmy on 04/09/2024.
//

import APIGateProtocol
import DataRepositoryProtocol
import BusinessLayerProtocol
import Foundation

protocol DependencyContainerProtocol {
    var networking: NetworkProtocol { get }
    var characterRepository: CharacterRepositoryProtocol { get }
    var fetchCharactersUseCase: FetchCharactersUseCaseProtocol { get }
    
    func makeCharactersViewModel() -> CharactersViewModelProtocol
    func makeCharactersViewController() -> CharactersViewController
    func makeCharacterDetailsViewController(character: Character, coordinator: CharactersCoordinator) -> CharacterDetailsViewController

}

enum DependencyContainerFactory {
    public static func defaultContainer() -> DependencyContainerProtocol {
        return DefaultDependencyContainer()
    }
}
