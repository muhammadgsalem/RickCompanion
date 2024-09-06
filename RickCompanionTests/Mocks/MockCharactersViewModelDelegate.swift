//
//  MockCharactersViewModelDelegate.swift
//  RickCompanionTests
//
//  Created by Jimmy on 06/09/2024.
//

import XCTest
@testable import RickCompanion
@testable import BusinessLayer
@testable import DataRepository

class MockCharactersViewModelDelegate: CharactersViewModelDelegate {
    var lastState: ViewState?

    func viewModelDidUpdateState(_ viewModel: CharactersViewModel, state: ViewState) {
        lastState = state
    }
}
