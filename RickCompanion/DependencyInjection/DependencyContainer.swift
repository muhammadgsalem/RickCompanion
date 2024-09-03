//
//  DependencyContainer.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation
import APIGate
import BusinessLayer


protocol DependencyContainerProtocol {
    func makeCharactersViewModel() -> CharactersViewModel
    func makeCharactersViewController() -> CharactersViewController
}


// DependencyContainer class manages all dependencies in the app
final class DependencyContainer: DependencyContainerProtocol {
    private let networking: Networking
    private let characterRepository: CharacterRepository
    private let fetchCharactersUseCase: FetchCharactersUseCase

    // Initializer for injecting dependencies
    init(networking: Networking,
         characterRepository: CharacterRepository,
         fetchCharactersUseCase: FetchCharactersUseCase) {
        self.networking = networking
        self.characterRepository = characterRepository
        self.fetchCharactersUseCase = fetchCharactersUseCase
    }

    // Factory method to create CharacterViewModel
    func makeCharactersViewModel() -> CharactersViewModel {
        return CharactersViewModel(fetchCharactersUseCase: fetchCharactersUseCase)
    }
    
    // Factory method to create CharactersViewController
    func makeCharactersViewController() -> CharactersViewController {
        let viewModel = makeCharactersViewModel()
        return CharactersViewController(viewModel: viewModel)
    }
    

}
