//
//  CharactersViewModel.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import BusinessLayerProtocol
import DataRepositoryProtocol
import Foundation

protocol CharactersViewModelProtocol {
    func loadCharacters(onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)
    func resetPagination()
    var characters: [Character] { get }
}

class CharactersViewModel: CharactersViewModelProtocol {
    private let fetchCharactersUseCase: FetchCharactersUseCaseProtocol
    private var currentPage = 1 // Tracks the current page
    private var isFetching = false // Prevents multiple fetches at the same time
    private var hasMorePages = true
    var characters = [Character]()

    init(fetchCharactersUseCase: FetchCharactersUseCaseProtocol) {
        self.fetchCharactersUseCase = fetchCharactersUseCase
    }

    func loadCharacters(onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        guard !isFetching && hasMorePages else { return }
        isFetching = true

        fetchCharactersUseCase.execute(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false

            switch result {
            case .success(let newCharacters):
                self.hasMorePages = (newCharacters.info.next != nil) // No more pages to load
                self.characters.append(contentsOf: newCharacters.results)
                self.currentPage += 1
                onSuccess()
            case .failure(let error):
                onError(error)
            }
        }
    }

    func resetPagination() {
        currentPage = 1
        hasMorePages = true
        characters.removeAll()
    }
}
