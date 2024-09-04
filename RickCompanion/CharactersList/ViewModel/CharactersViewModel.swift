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
    var currentFilter: CharacterStatus? { get }
    var delegate: CharactersViewModelDelegate? { get set }
    func loadCharacters()
    func resetPagination()
    func loadMoreCharactersIfNeeded(for index: Int)
    func applyFilter(_ filter: CharacterStatus?)
}

class CharactersViewModel: CharactersViewModelProtocol {
    private let fetchCharactersUseCase: FetchCharactersUseCaseProtocol
    private var currentPage = 1
    private var isFetching = false
    private var hasMorePages = true
    private(set) var characters = [Character]()
    private(set) var currentFilter: CharacterStatus?
    weak var delegate: CharactersViewModelDelegate?
    private var state: ViewState = .idle {
        didSet {
            delegate?.viewModelDidUpdateState(self, state: state)
        }
    }

    init(fetchCharactersUseCase: FetchCharactersUseCaseProtocol) {
        self.fetchCharactersUseCase = fetchCharactersUseCase
    }

    func loadCharacters() {
        guard !isFetching && hasMorePages else { return }
        isFetching = true
        state = .loading

        let status = currentFilter?.rawValue.lowercased() ?? ""
        fetchCharactersUseCase.execute(page: currentPage, status: status) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false

            switch result {
            case .success(let newCharacters):
                self.hasMorePages = (newCharacters.info.next != nil)
                self.characters.append(contentsOf: newCharacters.results)
                self.currentPage += 1
                self.state = .loaded(self.characters)
            case .failure(let error):
                self.state = .error(error)
            }
        }
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
            loadCharacters() // Automatically load the first page with the new filter
        }
    }

    func loadMoreCharactersIfNeeded(for index: Int) {
        guard index == characters.count - 1 else { return }
        loadCharacters()
    }
}

protocol CharactersViewModelDelegate: AnyObject {
    func viewModelDidUpdateState(_ viewModel: CharactersViewModel, state: ViewState)
}

enum CharacterStatus: String, CaseIterable {
    case all = "All"
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "Unknown"
}

enum ViewState {
    case idle
    case loading
    case loaded([Character])
    case error(Error)
}
