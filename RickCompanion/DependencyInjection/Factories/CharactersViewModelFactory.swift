//
//  CharactersViewModelFactory.swift
//  RickCompanion
//
//  Created by Jimmy on 05/09/2024.
//

import Foundation
protocol CharactersViewModelFactory {
    func makeCharactersViewModel() -> CharactersViewModelProtocol
}
