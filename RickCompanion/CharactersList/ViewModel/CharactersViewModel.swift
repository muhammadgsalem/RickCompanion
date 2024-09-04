//
//  CharactersViewModel.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import BusinessLayer
import DataRepository
import Foundation

protocol CharactersViewModelProtocol: AnyObject {
    var characters: [Character] { get }
    func loadCharacters(onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)
    func resetPagination()
    func loadMoreCharactersIfNeeded(for index: Int)
}

class CharactersViewModel: CharactersViewModelProtocol {
    private let fetchCharactersUseCase: FetchCharactersUseCaseProtocol
    private var currentPage = 1
    private var isFetching = false
    private var hasMorePages = true
    private(set) var characters = [Character]()

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
                self.hasMorePages = (newCharacters.info.next != nil)
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

    func loadMoreCharactersIfNeeded(for index: Int) {
        guard index == characters.count - 1 else { return }
        loadCharacters(onSuccess: {}, onError: { _ in })
    }
}
