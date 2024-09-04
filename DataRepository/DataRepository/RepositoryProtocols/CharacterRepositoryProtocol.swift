//
//  CharacterRepositoryProtocol.swift
//  DataRepository
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation
import APIGate

public protocol CharacterRepositoryProtocol {
    func fetchCharacters(page: Int, status: String, completion: @escaping (Result<CharacterResponse, RepositoryError>) -> Void)
}

