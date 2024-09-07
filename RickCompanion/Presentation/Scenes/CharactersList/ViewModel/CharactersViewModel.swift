//
//  CharactersViewModel.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import BusinessLayer
import DataRepository
import Foundation

/// A view model that manages the data and business logic for the characters list.
///
/// This view model is responsible for:
/// - Fetching characters from the use case
/// - Managing pagination
/// - Handling character filtering
/// - Notifying the view controller of state changes
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
    
    /// Indicates whether more pages can be loaded.
    var canLoadMorePages: Bool {
        !isFetching && hasMorePages
    }
    
    /// Initializes a new instance of `CharactersViewModel`.
    ///
    /// - Parameter fetchCharactersUseCase: The use case responsible for fetching characters from the repository.
    init(fetchCharactersUseCase: FetchCharactersUseCaseProtocol) {
        self.fetchCharactersUseCase = fetchCharactersUseCase
    }

    /// Loads the next page of characters.
    ///
    /// This method handles pagination and updates the view model's state accordingly.
    /// It will only fetch new characters if there are more pages available and no fetch is currently in progress.
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

    /// Resets the pagination state.
    ///
    /// This method clears the current characters, resets the page counter, and sets the state to idle.
    func resetPagination() {
        currentPage = 1
        hasMorePages = true
        characters.removeAll()
        state = .idle
    }

    /// Applies a new filter to the character list.
    ///
    /// - Parameter filter: The new `CharacterStatus` filter to apply.
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

    /// Loads more characters if needed based on the current scroll position.
    ///
    /// - Parameter index: The index of the currently visible character.
    func loadMoreCharactersIfNeeded(for index: Int) {
        guard index == characters.count - 1 else { return }
        Task {
            await loadCharacters()
        }
    }
}


