//
//  CharactersViewModelProtocol.swift
//  RickCompanion
//
//  Created by Jimmy on 05/09/2024.
//

import Foundation
import DataRepository

@MainActor
protocol CharactersViewModelProtocol: AnyObject {
    var characters: [Character] { get }
    var currentFilter: CharacterStatus? { get }
    var delegate: CharactersViewModelDelegate? { get set }
    func loadCharacters() async
    func resetPagination()
    func loadMoreCharactersIfNeeded(for index: Int)
    func applyFilter(_ filter: CharacterStatus?)
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
