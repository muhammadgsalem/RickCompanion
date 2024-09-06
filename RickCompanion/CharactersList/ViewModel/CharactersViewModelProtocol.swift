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



enum CharacterStatus: String, CaseIterable {
    case all = "All"
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "Unknown"
}

enum ViewState: Equatable {
    case idle
    case loading
    case loaded([Character])
    case error(Error)
    
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case let (.loaded(lhsCharacters), .loaded(rhsCharacters)):
            return lhsCharacters == rhsCharacters
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
