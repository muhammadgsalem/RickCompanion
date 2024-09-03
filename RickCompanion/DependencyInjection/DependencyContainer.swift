//
//  DependencyContainer.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation
import APIGate
import BusinessLayer

final class DependencyContainer {
    static let shared = DependencyContainer()

    private init() {}

    // Network Layer
    private lazy var networking: Networking = {
        return URLSessionNetworking() // or any other implementation from APIGate
    }()

    // Repositories
    private lazy var characterRepository: CharacterRepository = {
        return CharacterRepository(networking: networking)
    }()

    // Use Cases
    private lazy var fetchCharactersUseCase: FetchCharactersUseCase = {
        return FetchCharactersUseCase(characterRepository: characterRepository)
    }()

    // View Models
    func makeCharacterViewModel() -> CharactersViewModel {
        return CharactersViewModel(fetchCharactersUseCase: fetchCharactersUseCase)
    }

    // View Controllers
    func makeCharactersViewController() -> CharactersViewController {
        let viewModel = makeCharacterViewModel()
        return CharactersViewController(viewModel: viewModel)
    }
}
