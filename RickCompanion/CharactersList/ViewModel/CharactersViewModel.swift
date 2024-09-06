//
//  CharactersViewModel.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import BusinessLayer
import DataRepository
import Foundation

@MainActor
class CharactersViewModel: CharactersViewModelProtocol {
    private let fetchCharactersUseCase: FetchCharactersUseCaseProtocol
    private var currentPage = 1
    private var isFetching = false
    private var hasMorePages = true
    
    private(set) var characters: [Character] = []
    private(set) var currentFilter: CharacterStatus?
    weak var delegate: CharactersViewModelDelegate?
    
    private var state: ViewState = .idle {
        didSet {
            delegate?.viewModelDidUpdateState(self, state: state)
        }
    }
    
    var canLoadMorePages: Bool {
        !isFetching && hasMorePages
    }
    
    init(fetchCharactersUseCase: FetchCharactersUseCaseProtocol) {
        self.fetchCharactersUseCase = fetchCharactersUseCase
    }

    func loadCharacters() async {
        guard canLoadMorePages else { return }
        isFetching = true
        state = .loading

        let status = currentFilter?.rawValue.lowercased() ?? ""
        
        do {
            let newCharacters = try await fetchCharactersUseCase.execute(page: currentPage, status: status)
            self.hasMorePages = (newCharacters.info.next != nil)
            self.characters.append(contentsOf: newCharacters.results)
            self.currentPage += 1
            self.state = .loaded(self.characters)
        } catch {
            self.state = .error(error)
        }
        
        self.isFetching = false
    }

    func resetPagination() {
        currentPage = 1
        hasMorePages = true
        characters.removeAll()
        state = .idle
    }

    func applyFilter(_ filter: CharacterStatus?) {
        if filter != currentFilter {
            currentFilter = filter
            characters.removeAll()
            resetPagination()
            Task {
                await loadCharacters()
            }
        }
    }

    func loadMoreCharactersIfNeeded(for index: Int) {
        guard index == characters.count - 1 else { return }
        Task {
            await loadCharacters()
        }
    }
}


