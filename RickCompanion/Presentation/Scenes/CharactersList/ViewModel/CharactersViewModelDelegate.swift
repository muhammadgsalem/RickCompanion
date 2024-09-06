//
//  CharactersViewModelDelegate.swift
//  RickCompanion
//
//  Created by Jimmy on 06/09/2024.
//

import Foundation
protocol CharactersViewModelDelegate: AnyObject {
    func viewModelDidUpdateState(_ viewModel: CharactersViewModel, state: ViewState)
}
