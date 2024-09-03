//
//  DependencyContainer.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation
import APIGate
import BusinessLayer

// DependencyContainer class manages all dependencies in the app
final class DependencyContainer {
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

    // Factory method for production environment
    static func makeDefault() -> DependencyContainer {
        let networking = URLSessionNetworking() // Concrete implementation of Networking protocol
        let characterRepository = CharacterRepository(networking: networking) // Concrete CharacterRepository
        let fetchCharactersUseCase = FetchCharactersUseCase(characterRepository: characterRepository) // Concrete FetchCharactersUseCase
        
        return DependencyContainer(networking: networking,
                                   characterRepository: characterRepository,
                                   fetchCharactersUseCase: fetchCharactersUseCase)
    }

    // Factory method to create CharacterViewModel
    func makeCharacterViewModel() -> CharactersViewModel {
        return CharactersViewModel(fetchCharactersUseCase: fetchCharactersUseCase)
    }
    
    // Factory method to create CharactersViewController
    func makeCharactersViewController() -> CharactersViewController {
        let viewModel = makeCharacterViewModel()
        return CharactersViewController(viewModel: viewModel)
    }
    
//    // Example of another factory method to create another ViewModel
//    func makeCharacterDetailViewModel(character: Character) -> CharacterDetailViewModel {
//        return CharacterDetailViewModel(character: character)
//    }
//
//    // Add more factory methods for other ViewModels or dependencies as needed
}
