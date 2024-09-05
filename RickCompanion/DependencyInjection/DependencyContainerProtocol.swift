//
//  DependencyContainerProtocol.swift
//  RickCompanion
//
//  Created by Jimmy on 04/09/2024.
//

import Foundation
import DataRepository

protocol DependencyContainerProtocol: CharactersViewModelFactory {
    func makeCharactersViewModel() -> CharactersViewModelProtocol
    func makeCharactersViewController(coordinator: CharactersCoordinator) -> CharactersViewController
    func makeCharacterDetailsViewController(character: Character, coordinator: CharacterDetailCoordinator) -> CharacterDetailsViewController
}
